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
  $tls_auth_enabled = undef,
  $tls_auth_content = undef,
  $tls_auth_file = undef,
  $mute = undef,
) {
  if $tls_auth_enabled and !$tls_auth_content and !$tls_auth_file {
    fail("Enabling 'tls_auth_enabled' requires setting 'tls_auth_content' or 'tls_auth_file' too.")
  }
  openvpn::config { $title:
    role             => 'client',
    remote           => $remote,
    proto            => $proto,
    port             => $port,
    dev              => $dev,
    user             => $user,
    group            => $group,
    verb             => $verb,
    ca               => $ca,
    cert             => $cert,
    key              => $key,
    tls_auth_enabled => $tls_auth_enabled,
    tls_auth_content => $tls_auth_content,
    tls_auth_file    => $tls_auth_file,
  }
}
