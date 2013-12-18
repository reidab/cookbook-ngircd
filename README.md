Description
===========

Installs/Configures ngircd

Will likely add Server Peering/Configuration over the next few weeks.

Requirements
============

* Chef 0.8+
* Ubuntu >= 12.04

Attributes
==========

* `default['ngircd']['conf']` - The path to the server's config file.
* `default['ngircd']['motd']` - The path to the server's motd file.
* `default['ngircd']['server_name']` - IRC server's name.
* `default['ngircd']['admin_name']` - Administrator's name.
* `default['ngircd']['admin_location']` - Server's location.
* `default['ngircd']['admin_email']` - Administrator's email.
* `default['ngircd']['listen_address']` - IP address on which the server should listen.
* `default['ngircd']['motd_text']` - Text to use as the IRC server's motd.
* `default['ngircd']['server_password']` - Global password for all users needed
  to connect to the server.
* `default['ngircd']['pid_file']` - Path to the server's pid file.
* `default['ngircd']['group']` - The group the server runs as.
* `default['ngircd']['user']` - The user the server runs as.
* `default['ngircd']['use_ssl']` - The server uses SSL (default: true).
* `default['ngircd']['ssl_req']` - String used to generate a self-signed SSL
  cert.
* `default['ngircd']['ssl_ports']` - An array containing the IRC server's SSL
  listen ports.
* `default['ngircd']['non_ssl_ports']` - An aray containing the IRC servers
  non-SSL listen ports.
* `default['ngircd']['limits']['connect_retry']` - The server tries every
  <connect_retry> seconds to establish a link to not yet (or no longer)
  connected servers.
* `default['ngircd']['limits']['max_connections']` - Maximum number of
  simultaneous connection the server is allowed to accept (0: unlimited).
* `default['ngircd']['limits']['max_connections_ip']` - Maximum number of
  simultaneous connections from a single IP address the server will accept
  (0: unlimited).
* `default['ngircd']['limits']['max_joins']` - Maximum number of channels a
  user can be member of (0: no limit).
* `default['ngircd']['limits']['max_nick_length']` - Maximum length of an user
  nick name (Default: 9, as in RFC 2812).
* `default['ngircd']['limits']['ping_timeout']` - After <ping_timeout> seconds
  of inactivity the server will send a PING to the peer to test whether it is
  alive or not.
* `default['ngircd']['limits']['pong_timeout']` - If a client fails to answer a
  PING with a PONG within <pong_timeout> seconds, it will be disconnected by
  the server.
* `default['ngircd']['options']['cloak_host']` - Set this hostname for
  every client instead of the real one.
* `default['ngircd']['options']['cloak_user_to_nick']` - Set every clients'
  user name to their nick name.
* `default['ngircd']['options']['connect_ipv6']` - Try to connect to other irc
  servers using ipv6, if possible.
* `default['ngircd']['options']['connect_ipv4']` - Try to connect to other irc
  servers using ipv4, if possible.
* `default['ngircd']['options']['dns']` - Don do any DNS lookups when a client
  connects to the server.
* `default['ngircd']['options']['ident'` - Do IDENT lookups, if ngIRCd has been
  compiled with support for it.
* `default['ngircd']['options']['more_privacy']` - Enhance user privacy
  slightly (useful for IRC server on TOR or I2P) by censoring some information
  like idle time, logon time, etc.
* `default['ngircd']['options']['notice_auth']` - Normally ngIRCd doesn't send
  any messages to a client until it is registered. Enable this option to let
  the daemon send "NOTICE AUTH" messages to clients while connecting.
* `default['ngircd']['oper_can_use_mode']` - Should IRC Operators be allowed to
  use the MODE command even if they are not(!) channel-operators?
* `default['ngircd']['options']['oper_server_mode']` - Mask IRC Operator mode
  requests as if they were coming from the server?
* `default['ngircd']['options']['pam']` - Use PAM if ngIRCd has been compiled
  with support for it.
* `default['ngircd']['options']['predef_channels_only']` - Allow Pre-Defined
  Channels only (see Section [Channels]).
* `default['ngircd']['options']['require_auth_ping']` - Let ngIRCd send an
  "authentication PING" when a new client connects, and register this client
  only after receiving the corresponding "PONG" reply.
* `default['ngircd']['options']['scrub_ctcp']` - Silently drop all incoming
  CTCP requests.
* `default['ngircd']['options']['syslog_facility']` - Syslog "facility" to
  which ngIRCd should send log messages.
* `default['ngircd']['options']['webirc_password']` - Password required for
  using the WEBIRC command used by some Web-to-IRC gateways. If not set/empty,
  the WEBIRC command can't be used.
* `default['ngircd']['operators']` - Define IRC operators.  An array of hashes
  can be used to configure operators.  See example(s) below.
* `default['ngircd']['channels']` - Pre-defined channels can be configured, and
  created when the server starts.  An array of hashes can be used to configure
  such channels.  See example(s) below.

Creating operators.  This is generally set by a wrapper cookbook, and populated
by an encrypted data bag.

```json
"operators": [{
    "name": "name of oper",
    "password": "oper password"
}]
```

Creating channels.

```json
"channels": [{
    "name": "name of channel",
    "topic": "channel topic",
    "modes": "channel modes",
    "key": "channel key (optional, include 'k' in modes to require key)"
}]
```

Usage
=====

```json
"run_list": [
    "recipe[ngircd::server]"
]
```

server
----

Installs/Configures ngircd

Testing
=====

This cookbook uses [ChefSpec](https://github.com/acrmp/chefspec) for
unit-tests, and [Test Kitchen](https://github.com/opscode/test-kitchen)
for integration testing.

They don't play together nicely, due to JSON requirements.  So twiddling
of the Gemfile is required when running tests.

ChefSpec:

    $ cd $repo # Twiddle Gemfile
    $ bundle
    $ librarian-chef install
    $ ln -s ../ cookbooks/ngircd
    $ rspec cookbooks/ngircd

Test Kitchen:

    $ cd $repo # Twiddle Gemfile
    $ bundle
    $ kitchen test --platform ubuntu-12.04

License and Author
==================

Author:: John Dewey (<john@dewey.ws>)

Copyright 2012, John Dewey

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and 
limitations under the License.
