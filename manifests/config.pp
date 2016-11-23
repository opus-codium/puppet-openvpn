define openvpn::config (
  $role,
  $server_network = undef,
  $server_netmask = undef,
  $remote_host = undef,
  $remote_port = undef,
  $remote_proto = undef,
  $proto = 'udp',
  $port = 1194,
  $dev = 'tun',
  $topology = undef,
  $user = undef,
  $group = undef,
  $verb = undef,
  $ca = undef,
  $dh = undef,
  $cert = undef,
  $key = undef,
  $tls_auth_enabled = false,
  $tls_auth_content = undef,
  $tls_auth_file = undef,
  $crl_verify_file = undef,
  $status = undef,
  $status_version = undef,
  $ifconfig_pool_persist_enabled = undef,
  $ifconfig_pool_persist_file = undef,
  $max_clients = undef,
  $mute = undef,
  $plugins = [],
  $push = [],
  $manage_service = true,
) {
  include openvpn

  validate_re($role, ['^server$', '^client$'])

  if $tls_auth_file and $tls_auth_content {
    fail("You cannot pass both 'tls_auth_content' and 'tls_auth_file'")
  }

  if $role == 'server' {
    validate_re($topology, ['^net30$', '^p2p$', '^subnet$'])
    validate_ip_address($server_network)
    validate_ip_address($server_netmask)
  } else {
    if $remote_host == undef { fail('remote_host must be set') }
  }

  $filename = "${openvpn::etcdir}/${title}.conf"

  if $tls_auth_file {
    $real_tls_auth_file = $tls_auth_file
  } else {
    $real_tls_auth_file = "${openvpn::etcdir}/${title}-ta.key"
  }

  if $tls_auth_enabled or $tls_auth_content or $tls_auth_file {
    if $tls_auth_content {
      file { $real_tls_auth_file:
        ensure  => file,
        owner   => $openvpn::admin_user,
        group   => $openvpn::admin_group,
        mode    => '0600',
        content => $tls_auth_content,
      }
    } elsif $tls_auth_file {
      # Nada
    } else {
      exec { "${openvpn::openvpn} --genkey --secret \"${real_tls_auth_file}\"":
        creates => $real_tls_auth_file,
      }
      ->
      file { $real_tls_auth_file:
        ensure => file,
        owner  => $openvpn::admin_user,
        group  => $openvpn::admin_group,
        mode   => '0600',
      }
    }
  }

  concat { "${openvpn::etcdir}/${title}.conf":
    ensure => present,
    owner  => 'root',
    group  => $::openvpn::admin_group,
    mode   => '0600',
  }

  concat::fragment { "${title}-openvpn.conf-base":
    target  => $filename,
    content => template('openvpn/base.erb'),
    order   => '010',
  }

  concat::fragment { "${title}-openvpn.conf-keepalive":
    target  => $filename,
    content => template('openvpn/keepalive.erb'),
    order   => '011',
  }

  if $ca or $cert or $key {
    if $ca == undef { fail('ca must be set') }
    if $cert == undef { fail('cert must be set') }
    if $key == undef { fail('key must be set') }
    if $role == 'server' and $dh == undef { fail('dh must be set') }

    concat::fragment { "${title}-openvpn.conf-tls":
      target  => $filename,
      content => template('openvpn/tls.erb'),
      order   => '020',
    }
  }

  concat::fragment { "${title}-openvpn.conf-ciphers":
    target  => $filename,
    content => template('openvpn/ciphers.erb'),
    order   => '030',
  }

  concat::fragment { "${title}-openvpn.conf-compression":
    target  => $filename,
    content => template('openvpn/compression.erb'),
    order   => '040',
  }

  if $max_clients {
    concat::fragment { "${title}-openvpn.conf-max-clients":
      target  => $filename,
      content => template('openvpn/max-clients.erb'),
      order   => '045',
    }
  }

  if $user and $group {
    concat::fragment { "${title}-openvpn.conf-run-as":
      target  => $filename,
      content => template('openvpn/run-as.erb'),
      order   => '050',
    }
  }

  concat::fragment { "${title}-openvpn.conf-persist":
    target  => $filename,
    content => template('openvpn/persist.erb'),
    order   => '051',
  }

  if $status {
    concat::fragment { "${title}-openvpn.conf-status":
      target  => $filename,
      content => template('openvpn/status.erb'),
      order   => '055',
    }

    file { "${openvpn::etcdir}/${title}-status.log":
      ensure => file,
      owner  => $user,
      group  => $group,
      mode   => '0644',
    }
  }

  if $ifconfig_pool_persist_enabled {
    if $ifconfig_pool_persist_file {
      $real_ifconfig_pool_persist_file = $ifconfig_pool_persist_file
    } else {
      $real_ifconfig_pool_persist_file = "${openvpn::etcdir}/${title}-ipp.txt"
    }
    concat::fragment { "${title}-openvpn.conf-ipp":
      target  => $filename,
      content => template('openvpn/ipp.erb'),
      order   => '056',
    }

    file { $real_ifconfig_pool_persist_file:
      ensure => file,
      owner  => $user,
      group  => $group,
      mode   => '0644',
    }
  }

  if $verb {
    concat::fragment { "${title}-openvpn.conf-verb":
      target  => $filename,
      content => template('openvpn/verb.erb'),
      order   => '060',
    }
  }

  if $mute {
    concat::fragment { "${title}-openvpn.conf-mute":
      target  => $filename,
      content => template('openvpn/mute.erb'),
      order   => '061',
    }
  }

  if count($plugins) > 0 {
    concat::fragment { "${title}-openvpn.conf-plugins":
      target  => $filename,
      content => template('openvpn/plugins.erb'),
      order   => '062',
    }
  }

  if count($push) > 0 {
    concat::fragment { "${title}-openvpn.conf-push":
      target  => $filename,
      content => template('openvpn/push.erb'),
      order   => '063',
    }
  }

  openvpn::service { $title:
    manage_service => $manage_service,
  }
}
