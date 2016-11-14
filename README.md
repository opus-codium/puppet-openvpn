# openvpn

[![Build Status](https://travis-ci.org/opus-codium/puppet-openvpn.svg?branch=master)](https://travis-ci.org/opus-codium/puppet-openvpn)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with openvpn](#setup)
    * [What openvpn affects](#what-openvpn-affects)
    * [Beginning with openvpn](#beginning-with-openvpn)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)

## Overview

Manageable independent OpenVPN nodes in client/server mode.

## Module Description

This module installs OpenVPN and helps configuring any number of instances that
can be managed individually.

## Setup

### What openvpn affects

Well… OpenVPN configuration.

**Please note that any existing configuration will be removed by this module
unless explicitely configured through Puppet.**

### Beginning with openvpn

~~~puppet
openvpn::server { 'server':
  server_netowrk => '192.168.0.0',
  server_netmask => '255.255.255.0',
}

openvpn::client { 'client':
  remote => 'server.example.com',
}
~~~

## Usage

Only the `openvpn::client` and `openvpn::server` classes are intended to end
users usage. See reference documentation bellow.

## Reference



## Limitations

The current implementation supports Debian GNU/Linux and FreeBSD.  Patches to
add support to more platforms are welcome.

## Contributing

1. Fork it ( https://github.com/opus-codium/puppet-openvpn/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request
