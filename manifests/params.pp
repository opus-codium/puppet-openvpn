class openvpn::params {
  case $::osfamily {
    'debian': {
      $etcdir = '/etc/openvpn'
      $admin_group = 'root'
    }
    'freebsd': {
      $etcdir = '/usr/local/etc/openvpn'
      $admin_group = 'wheel'
    }
    default: {
      fail("Unsupported operating system ${::osfamily}")
    }
  }
}
