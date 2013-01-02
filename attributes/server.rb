#
# Cookbook Name:: cookbook-ngircd
# Recipe:: server
#
# Copyright 2012, John Dewey
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['ngircd']['dir'] = ::File.join ::File::SEPARATOR, "etc", "ngircd"
default['ngircd']['conf'] = ::File.join node['ngircd']['dir'], "ngircd.conf"
default['ngircd']['motd'] = ::File.join node['ngircd']['dir'], "ngircd.motd"
default['ngircd']['server_name'] = "irc.example.net"
default['ngircd']['admin_name'] = "Debian User"
default['ngircd']['admin_location'] = "Debian City"
default['ngircd']['admin_email'] = "irc@irc.example.com"
default['ngircd']['listen_address'] = "0.0.0.0"
default['ngircd']['motd_text'] = nil
default['ngircd']['server_password'] = nil
default['ngircd']['pid_file'] = ::File.join ::File::SEPARATOR, "var", "run", "ngircd", "ngircd.pid"
default['ngircd']['group'] = "irc"
default['ngircd']['user'] = "irc"
default['ngircd']['non_ssl_ports'] = [ "6667" ]
default['ngircd']['use_ssl'] = true
default['ngircd']['ssl_req'] = "/C=US/ST=Several/L=Locality/O=Example/OU=Operations/CN=#{node['ngircd']['server_name']}/emailAddress=#{node['ngircd']['admin_email']}"
default['ngircd']['ssl_ports'] = [ "6697" ]

default['ngircd']['limits']['connect_retry'] = "60"
default['ngircd']['limits']['max_connections'] = "500"
default['ngircd']['limits']['max_connections_ip'] = "10"
default['ngircd']['limits']['max_joins'] = "10"
default['ngircd']['limits']['max_nick_length'] = "9"
default['ngircd']['limits']['ping_timeout'] = "120"
default['ngircd']['limits']['pong_timeout'] = "20"

default['ngircd']['options']['allow_remote_oper'] = "no"
default['ngircd']['options']['chroot_dir'] = "/var/empty"
default['ngircd']['options']['cloak_host'] = "irc.example.net"
default['ngircd']['options']['cloak_user_to_nick'] = "yes"
default['ngircd']['options']['connect_ipv6'] = "yes"
default['ngircd']['options']['connect_ipv4'] = "yes"
default['ngircd']['options']['dns'] = "yes"
default['ngircd']['options']['ident'] = "no"
default['ngircd']['options']['more_privacy'] = "no"
default['ngircd']['options']['notice_auth'] = "no"
default['ngircd']['options']['oper_can_use_mode'] = "yes"
default['ngircd']['options']['oper_server_mode'] = "no"
default['ngircd']['options']['pam'] = "no"
default['ngircd']['options']['predef_channels_only'] = "no"
default['ngircd']['options']['require_auth_ping'] = "no"
default['ngircd']['options']['scrub_ctcp'] = "no"
default['ngircd']['options']['syslog_facility'] = "local1"
default['ngircd']['options']['webirc_password'] = "xyz"

default['ngircd']['operators'] = {}
default['ngircd']['channels'] = {}
