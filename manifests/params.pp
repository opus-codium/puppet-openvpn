class openvpn::params {
  case $::osfamily {
    'debian': {
      $admin_user = 'root'
      $admin_group = 'root'
      $etcdir = '/etc/openvpn'
      $openvpn = '/usr/sbin/openvpn'
    }
    'freebsd': {
      $admin_user = 'root'
      $admin_group = 'wheel'
      $etcdir = '/usr/local/etc/openvpn'
      $openvpn = '/usr/local/sbin/openvpn'
    }
    default: {
      fail("Unsupported operating system ${::osfamily}")
    }
  }
}
