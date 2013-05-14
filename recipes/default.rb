#
# Cookbook Name:: pantry
# Recipe:: default
#
# Copyright 2013, Wonga Technology Ltd.
#
# All rights reserved - Do Not Redistribute
#
directory "#{node['pantry']['deploy_path']}/bin" do
  owner node['pantry']['user']
  mode 755
  recursive true
end

cookbook_file "#{node['pantry']['deploy_path']}/bin/wrap-ssh4git.sh" do
  source "wrap-ssh4git.sh"
  owner node['pantry']['user']
  mode 00700
end

deploy "pantry" do
  repo "git@github.com:QuickBridgeLtd/lakitu.git"
  user node['pantry']['user']
  deploy_to "/home/pantry/pantry"
  action :deploy
  ssh_wrapper "#{node['pantry']['deploy_path']}/bin/wrap-ssh4git.sh"
end


