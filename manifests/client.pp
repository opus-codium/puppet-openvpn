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
  $ta_content = undef,
  $mute = undef,
) {
  if $ta and !$ta_content {
    fail("Enabling 'ta' requires setting 'ta_content' too.")
  }
  openvpn::config { $title:
    role       => 'client',
    remote     => $remote,
    proto      => $proto,
    port       => $port,
    dev        => $dev,
    user       => $user,
    group      => $group,
    verb       => $verb,
    ca         => $ca,
    cert       => $cert,
    key        => $key,
    ta         => $ta,
    ta_content => $ta_content,
  }
}
