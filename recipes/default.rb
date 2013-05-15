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
  mode 0755
  recursive true
end

deploy_user = data_bag_item('users', node['pantry']['user'])

application "pantry" do
  repository node['pantry']['repo']
  owner node['pantry']['user']
  group node['pantry']['group']
  path node['pantry']['deploy_path']
  environment_name node['pantry']['deploy_environment']
  deploy_key deploy_user['ssh_private_key']
  packages [ "libxml2-dev", "libxslt1-dev", "libmysqlclient-dev" ]
  action :force_deploy

  rails do
      gems [ "bundler" ]
      database do
          database "mysql"
          username "pantry"
          password "pantry"
      end
  end

end


