#
# Cookbook Name:: pantry
# Recipe:: rubygems
#
# Copyright 2014, Wonga Technology Ltd.
#
# All rights reserved - Do Not Redistribute
#

rubygems_host = node['pantry']['rubygems']['rubygems_host']
credentials = nil

if node['pantry']['rubygems']['username'] && node['pantry']['rubygems']['password']
  credentials = "#{node['pantry']['rubygems']['username']}:#{node['pantry']['rubygems']['password']}"
  rubygems_host = rubygems_host.gsub(%r{https?://}, "\\0#{credentials}@")
end
rubygems_host = "#{rubygems_host}/" unless rubygems_host[-1] == '/'

bash 'Add gem source' do
  code "gem sources -a #{rubygems_host}"
  user node['pantry']['user']
  group node['pantry']['group']
  environment ({ 'HOME' => ::Dir.home(node['pantry']['user']), 'USER' => node['pantry']['user'] })
end

bash 'Set credentials' do
  code "curl #{node['pantry']['rubygems']['rubygems_key_url']} -u #{credentials} > ~/.gem/credentials"
  user node['pantry']['user']
  group node['pantry']['group']
  environment ({ 'HOME' => ::Dir.home(node['pantry']['user']), 'USER' => node['pantry']['user'] })
  action :nothing
end

template '/etc/profile.d/rubygems.sh' do
  mode 0755
  action :create
  variables({
    host: node['pantry']['rubygems']['rubygems_host']
  })
  notifies :run, 'bash[Set credentials]'
  only_if { node['pantry']['rubygems']['set_push_credentials'] && credentials }
end
