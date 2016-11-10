class openvpn (
  $admin_user = $openvpn::params::admin_user,
  $admin_group = $openvpn::params::admin_group,
  $etcdir = $openvpn::params::etcdir,
  $openvpn = $openvpn::params::openvpn,
) inherits openvpn::params {
  package { 'openvpn':
    ensure => installed,
  }

  file { $etcdir:
    ensure  => directory,
    owner   => $admin_user,
    group   => $admin_group,
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
