#
# Cookbook Name:: pantry
# Recipe:: default
#
# Copyright 2013, Wonga Technology Ltd.
#
# All rights reserved - Do Not Redistribute
#
include_recipe "git"

directory "#{node['pantry']['deploy_path']}/bin" do
  owner node['pantry']['user']
  mode 755
  recursive true
end

template "#{node['pantry']['deploy_path']}/bin/wrap-ssh4git.sh" do
  source "wrap-ssh4git.sh.erb"
  owner node['pantry']['user']
  mode 00700
  variables(
      :deploy_path => node['pantry']['deploy_path'],
      :deploy_key => node['pantry']['deploy_key']
  )
end

application "pantry" do
  repository node['pantry']['repo']
  owner node['pantry']['user']
  group node['pantry']['group']
  path node['pantry']['deploy_path']
  environment_name node['pantry']['deploy_environment']
  #deploy_key "{#node['pantry']['deploy_path']}/.ssh/#{node['pantry']['deploy_key']}"
  ssh_wrapper "#{node['pantry']['deploy_path']}/bin/wrap-ssh4git.sh"

  rails do
      database do
          database "mysql"
          username "pantry"
          password "pantry"
      end
  end
end


