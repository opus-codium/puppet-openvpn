class openvpn inherits openvpn::params {
  package { 'openvpn':
    ensure => installed,
  }
}
