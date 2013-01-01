Description
===========

Installs/Configures ngircd

Requirements
============

* Chef 0.8+

Attributes
==========

* `default['ngircd']['dir']` - Path to the servers base directory.
* `default['ngircd']['conf']` - Path to the server's config file.
* `default['ngircd']['motd']` - Path to the server's motd file.
* `default['ngircd']['motd_text']` - Text to use as the IRC server's motd.
* `default['ngircd']['user']` -  The user the server runs as.
* `default['ngircd']['group']` - The group the server runs as.
* `default['ngircd']['pid_file']` - Path to the server's pid file.
* `default['ngircd']['server_password']` - Global password for all users needed
  to connect to the server.
* `default['ngircd']['listen_address']` - IP address on which the server should
  listen.
* `default['ngircd']['ping_timeout']` - After <ping_timeout> seconds of
  inactivity the server will send a PING to the peer to test whether it is
  alive or not.
* `default['ngircd']['pong_timeout']` - If a client fails to answer a PING with
  a PONG within <pong_timeout> seconds, it will be disconnected by the server.
* `default['ngircd']['connect_retry']` - The server tries every <connect_retry>
  seconds to establish a link to not yet (or no longer) connected servers.
* `default['ngircd']['oper_can_use_mode']` - Should IRC Operators be allowed to
  use the MODE command even if they are not(!) channel-operators?
* `default['ngircd']['max_connections']` - Maximum number of simultaneous
  connection the server is allowed to accept (<=0: unlimited).
* `default['ngircd']['max_connections_ip']` - Maximum number of simultaneous
  connections from a single IP address the server will accept (<=0: unlimited).
* `default['ngircd']['max_joins']` - Maximum number of channels a user can be
  member of (<=0: no limit).
* `default[:ngircd][:server_name]` - IRC server's name.
* `default[:ngircd][:admin_name]` - Administrator's name.
* `default[:ngircd][:admin_location]` - Server's location.
* `default[:ngircd][:admin_email]` - Administrator's email.
* `default['ngircd']['use_ssl']` - The server uses SSL (default: true).
* `default['ngircd']['ssl_req']` - String used to generate a self-signed SSL
  cert.
* `default['ngircd']['ssl_ports']` - An array containing the IRC server's SSL
  listen ports.
* `default['ngircd']['non_ssl_ports']` - An aray containing the IRC servers
  non-SSL listen ports.
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
    "modes": "channel modes"
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

This cookbook is using [ChefSpec](https://github.com/acrmp/chefspec) for testing.

    $ cd $repo
    $ bundle
    $ librarian-chef install
    $ ln -s ../ cookbooks/$short_repo_name # doesn't contain "cookbook-"
    $ foodcritic cookbooks/$short_repo_name
    $ rspec cookbooks/$short_repo_name

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
