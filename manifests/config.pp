define openvpn::config (
  $role,
  $server = undef,
  $netmask = undef,
  $remote = undef,
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
  $ta = undef,
  $crl = undef,
  $status = undef,
  $status_version = undef,
  $ipp_file = undef,
) {
  include openvpn

  validate_re($role, ['^server$', '^client$'])

  if $role == 'server' {
    validate_re($topology, ['^net30$', '^p2p$', '^subnet$'])
    validate_ip_address($server)
    validate_ip_address($netmask)
  } else {
    if $remote == undef { fail('remote must be set') }
  }

  $filename = "${openvpn::etcdir}/${title}.conf"

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

  if $user and $group {
    concat::fragment { "${title}-openvpn.conf-run-as":
      target  => $filename,
      content => template('openvpn/run-as.erb'),
      order   => '050',
    }
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

  if $ipp_file {
    concat::fragment { "${title}-openvpn.conf-ipp":
      target  => $filename,
      content => template('openvpn/ipp.erb'),
      order   => '056',
    }

    file { "${openvpn::etcdir}/${title}-ipp.log":
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

  openvpn::service { $title:
  }
}
