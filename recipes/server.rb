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


if node['ngircd']['use_ssl']
  execute "create self-signed cert" do
    cwd = node['ngircd']['dir']
    command <<-EOF.gsub(/^\s{6}/, "")
      umask 077
      openssl genrsa 2048 > irc.key
      openssl req -subj #{node['ngircd']['ssl_req']} -new -x509 -nodes -sha1 -days 3650 -key irc.key > irc.crt
      cat irc.key irc.crt > irc.pem
    EOF

    not_if { ::File.exists? ::File.join node['ngircd']['dir'], "irc.key" }
  end
end

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

  if node['ngircd']['use_ssl']
    ports = node['ngircd']['ssl_ports']
  else
    ports = node['ngircd']['non_ssl_ports']
  end

  variables(
    :ports => ports.join(",")
  )

  notifies :restart, resources(:service => "ngircd")
end
