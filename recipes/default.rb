#
# Cookbook Name:: pantry
# Recipe:: default
#
# Copyright 2013, Wonga Technology Ltd.
#
# All rights reserved - Do Not Redistribute
#

include_recipe "git"
include_recipe "runit"
include_recipe "passenger_apache2"

package node['pantry']['nodejs_package']

# We pull the ssh private key from the specified users data bag item
deploy_user_item = data_bag_item('users', node['pantry']['user'])
app_env = node['pantry']['app_environment']
app_path = node['pantry']['app_path']
app_port = node['pantry']['app_port']

# Get Pantry attributes from specified data bag item if it exists or fall back to attribute
begin
  app_data_bag_item = data_bag_item(node['pantry']['app_data_bag'], node['pantry']['app_data_bag_item'])
  app_revision = app_data_bag_item['app_revision']
rescue
  Chef::Log.warn "Data Bag #{node['pantry']['app_data_bag']} does not exist, falling back to attribute"
  app_revision = node['pantry']['app_revision']
end

# Get Pantry Chef credentials from specified data bag item if it exists of fall back to attributes
begin
  chef_data_bag_item = data_bag_item(node['pantry']['chef_data_bag'], node['pantry']['chef_data_bag_item'])
  knife_data = chef_data_bag_item['chef']
rescue
  Chef::Log.warn "Data Bag #{node['pantry']['app_data_bag']} does not exist, falling back to attribute"
  knife_data = node['pantry']['chef']
end

Chef::Log.info "#########################################"
Chef::Log.info "DEPLOYING PANTRY REVISION #{app_revision}"
Chef::Log.info "#########################################"

# rails database sub-resource can't access node attributes directly.
db_adapter = node['pantry']['database_adapter']
db_database = node['pantry']['database_name']
db_username = node['pantry']['database_username']
db_password = node['pantry']['database_password']

# Create the database and user
mysql_connection_info = {:host => 'localhost',
                         :username => 'root',
                         :password => node['mysql']['server_root_password']}

mysql_database_user db_username do
  connection mysql_connection_info
  password db_password
  host '%'
  database_name db_database
  privileges [:all]
  action :grant
end

mysql_database db_database do
  connection mysql_connection_info
  action :create
end

application "pantry" do
  repository node['pantry']['repo']
  owner node['pantry']['user']
  group node['pantry']['group']
  revision app_revision unless app_revision.nil?
  path app_path
  environment_name app_env
  migrate node['pantry']['app_migrate']
  deploy_key deploy_user_item['ssh_private_key']
  packages [ "libxml2-dev", "libxslt1-dev", "libmysqlclient-dev", "libcurl4-openssl-dev", "libpcre3-dev" ]
  action :force_deploy

  rails do
    precompile_assets app_env == "production"
    gems [ "bundler", "passenger", "unicorn" ]
    database_master_role node['pantry']['database_master_role']
    database do
      adapter db_adapter
      database db_database
      username db_username
      password db_password
    end
  end

  before_restart do
    execute "delayed_job Restart" do
      command "#{release_path}/script/delayed_job restart"
      environment ({"RAILS_ENV"=>"#{app_env}"})
      action :run
    end
  end

  passenger_apache2 do
    server_aliases node['pantry']['server_aliases']
    webapp_template node['pantry']['webapp_template']
  end
end

