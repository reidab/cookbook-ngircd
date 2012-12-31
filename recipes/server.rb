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

#creds = encrypted_data_bag "secrets", "irc"
#bash "installing a self-signed cert" do
#  code <<-EOF
#    openssl req \
#      -x509 -nodes -days 365 \
#      -subj "/C=US/ST=Palo Alto/L=California/CN=#{node[:ngircd][:server_name]}" \
#      -newkey rsa:1024 -keyout #{node[:ngircd][:ssl_key_file]} -out #{node[:ngircd][:ssl_key_file]}
#  EOF

#  not_if { ::File.exists? node[:ngircd][:ssl_key_file] }
#end

package "ngircd" do
  action :upgrade
end

service "ngircd" do
  supports :restart => true, :start => true

  action [:start, :enable]
end

if node['ngircd']['motd_text']
  template node['ngircd']['motd'] do
    source "ngircd.motd.erb"
    owner  node['ngircd']['user']
    group  node['ngircd']['group']
    mode   00644

    notifies :restart, resources(:service => "ngircd")
  end
end

template node['ngircd']['conf'] do
  source "ngircd.conf.erb"
  owner  "irc"
  group  "irc"
  mode   00600

  variables(
    :ports => node['ngircd']['ports'].join(",")
  )

  notifies :restart, resources(:service => "ngircd")
end
