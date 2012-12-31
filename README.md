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
* `default[:ngircd][:server_name]` - IRC server's name, also used when generating self signed cert.
* `default[:ngircd][:admin_name]` - Administrator's name.
* `default[:ngircd][:admin_location]` - Server's location.
* `default[:ngircd][:admin_email]` - Administrator's email.



## After <PingTimeout> seconds of inactivity the server will send a
## PING to the peer to test whether it is alive or not.
#PingTimeout = 120

## If a client fails to answer a PING with a PONG within <PongTimeout>
## seconds, it will be disconnected by the server.
#PongTimeout = 20

## The server tries every <ConnectRetry> seconds to establish a link
## to not yet (or no longer) connected servers.
#ConnectRetry = 60

## Should IRC Operators be allowed to use the MODE command even if
## they are not(!) channel-operators?
#OperCanUseMode = yes

## Maximum number of simultaneous connection the server is allowed
## to accept (<=0: unlimited):
#MaxConnections = 500

## Maximum number of simultaneous connections from a single IP address
## the server will accept (<=0: unlimited):
#MaxConnectionsIP = 10

## Maximum number of channels a user can be member of (<=0: no limit):
#MaxJoins = 10




#* `default[:ngircd][:ssl]` - Use SSL (default: true).
#If :ssl
#* `default[:ngircd][:ssl_ports]` = IRC server's ssl ports.
#* `default[:ngircd][:ssl_key_file]` = IRC server's ssl key file.
#* `default[:ngircd][:ssl_cert_file]` = IRC server's ssl cert file.
#Otherwise
#* `default[:ngircd][:non_ssl_ports]` - An array containing the IRC server's non-ssl listen ports.
#
#* These attributes are required.
#
#* `node[:ngircd][:operators]` - An array with server's operator information.
#
#    "operators": [
#      {
#        "name": "Name",
#      }
#    ]
#
#* `node[:ngircd][:channels]` - An array with server's chennel information.
#
#    "channels": [
#      {
#        "name": "Channel Name",
#        "topic": "Topic Name",
#        "modes": "Modes"
#      }
#    ]

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
