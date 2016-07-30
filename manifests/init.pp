class openvpn inherits openvpn::params {
  package { 'openvpn':
    ensure => installed,
  }

  file { $openvpn::params::etcdir:
    ensure  => directory,
    owner   => 'root',
    group   => $openvpn::params::admin_group,
    mode    => '0755',
    purge   => true,
    recurse => true,
    force   => true,
  }

  if $::osfamily == 'Debian' {
    # Debian's init script for OpenVPN are a PITA.
    #
    # Ensure the installed systemd units are inactive and handle our openvpn
    # connections ourself via openvpn::service
    service { 'openvpn':
      ensure => stopped,
      enable => false,
    }
  }
}
