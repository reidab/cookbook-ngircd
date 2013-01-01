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
default['ngircd']['motd_text'] = nil
default['ngircd']['user'] = "irc"
default['ngircd']['group'] = "irc"
default['ngircd']['pid_file'] = ::File.join ::File::SEPARATOR, "var", "run", "ngircd", "ngircd.pid"
default['ngircd']['server_password'] = nil
default['ngircd']['listen_address'] = "0.0.0.0"
default['ngircd']['ping_timeout'] = "120"
default['ngircd']['pong_timeout'] = "20"
default['ngircd']['connect_retry'] = "60"
default['ngircd']['oper_can_use_mode'] = "yes"
default['ngircd']['max_connections'] = "500"
default['ngircd']['max_connections_ip'] = "10"
default['ngircd']['max_joins'] = "10"
default['ngircd']['server_name'] = "irc.example.com"
default['ngircd']['admin_name'] = "Description"
default['ngircd']['admin_location'] = "Location"
default['ngircd']['admin_email'] = "admin@irc.server"
default['ngircd']['use_ssl'] = true
default['ngircd']['ssl_req'] = "/C=US/ST=Several/L=Locality/O=Example/OU=Operations/CN=#{node['ngircd']['server_name']}/emailAddress=#{node['ngircd']['admin_email']}"
default['ngircd']['ssl_ports'] = [ "6697" ]
default['ngircd']['non_ssl_ports'] = [ "6667" ]
default['ngircd']['operators'] = {}
default['ngircd']['channels'] = {}
