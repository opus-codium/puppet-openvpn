define openvpn::service (
  $manage_service = true,
) {
  case $::osfamily {
    'Debian': {
      $service_name = "openvpn-${title}"
      $service_provider = 'systemd'

      file { "/etc/systemd/system/${service_name}.service":
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('openvpn/openvpn.service.erb'),
      }

      exec { "systemd-conf-reload-${service_name}":
        command     => '/bin/systemctl daemon-reload',
        refreshonly => true,
      }

      File["/etc/systemd/system/${service_name}.service"] ~> Exec["systemd-conf-reload-${service_name}"]
      if $manage_service {
        Exec["systemd-conf-reload-${service_name}"] -> Service[$service_name]
      }
    }
    'FreeBSD': {
      $service_name = $title
      $service_provider = 'freebsd'

      file { "/usr/local/etc/rc.d/${service_name}":
        ensure => link,
        target => '/usr/local/etc/rc.d/openvpn',
      }

      if $manage_service {
        File["/usr/local/etc/rc.d/${service_name}"] -> Service[$service_name]
      }
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily}")
    }
  }

  if $manage_service {
    service { $service_name:
      ensure   => running,
      enable   => true,
      provider => $service_provider,
    }
  }
}
