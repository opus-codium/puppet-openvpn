class openvpn inherits openvpn::params {
  package { 'openvpn':
    ensure => installed,
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
