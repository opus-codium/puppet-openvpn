define openvpn::client (
  $remote,
  $proto = 'udp',
  $port = 1194,
  $dev = 'tun',
  $user = 'nobody',
  $group = 'nogroup',
  $verb = 3,
  $ca = undef,
  $cert = undef,
  $key = undef,
  $ta = undef,
) {
  openvpn::config { $title:
    role   => 'client',
    remote => $remote,
    proto  => $proto,
    port   => $port,
    dev    => $dev,
    user   => $user,
    group  => $group,
    verb   => $verb,
    ca     => $ca,
    cert   => $cert,
    key    => $key,
    ta     => $ta,
  }
}
