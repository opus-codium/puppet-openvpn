class openvpn::params {
  case $::osfamily {
    'Debian': {
      $etcdir = '/etc/openvpn'
      $admin_group = 'root'
    }
    'FreeBSD': {
      $etcdir = '/usr/local/etc/openvpn'
      $admin_group = 'wheel'
    }
    default: {
      fail("Unsupported operating system ${::osfamily}")
    }
  }
}
