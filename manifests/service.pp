define openvpn::service (
  $manage_service = true,
) {
  case $::osfamily {
    'Debian': {
      file { "/etc/systemd/system/${title}.service":
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('openvpn/openvpn.service.erb'),
      }

      exec { "systemd-conf-reload-${title}":
        command     => '/bin/systemctl daemon-reload',
        refreshonly => true,
      }

      File["/etc/systemd/system/${title}.service"] ~> Exec["systemd-conf-reload-${title}"]
      if $manage_service {
        Exec["systemd-conf-reload-${title}"] -> Service[$title]
      }
    }
    'FreeBSD': {
      file { "/usr/local/etc/rc.d/${title}":
        ensure => link,
        target => '/usr/local/etc/rc.d/openvpn',
      }

      if $manage_service {
        File["/usr/local/etc/rc.d/${title}"] -> Service[$title]
      }
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily}")
    }
  }

  if $manage_service {
    service { $title:
      ensure => running,
      enable => true,
    }
  }
}
