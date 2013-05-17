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

# We pull the ssh private key from the specified users data bag item
deploy_user_item = data_bag_item('users', node['pantry']['user'])
app_env = node['pantry']['deploy_environment']
app_path = node['pantry']['deploy_path']
app_port = node['pantry']['deploy_port']
app_pid = "#{node['pantry']['deploy_path']}/pantry.pid"
# rails database sub-resource can't access node attributes directly.
db_adapter = node['pantry']['database_adapter']
db_database = node['pantry']['database_name']
db_username = node['pantry']['database_username']
db_password = node['pantry']['database_password']

# Create the database and user
mysql_connection_info = {:host => "localhost",
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
    path app_path
    environment_name app_env
    deploy_key deploy_user_item['ssh_private_key']
    packages [ "libxml2-dev", "libxslt1-dev", "libmysqlclient-dev", "libcurl4-openssl-dev", "libpcre3-dev" ]
    action :force_deploy

    rails do
        gems [ "bundler", "passenger", "unicorn" ]
        database_master_role node['pantry']['database_master_role']
        database do
            adapter db_adapter
            database db_database
            username db_username
            password db_password
        end
    end

    #unicorn do
    #    worker_processes 2
    #end
    
    passenger_apache2 do
        server_aliases node['pantry']['server_aliases']
        webapp_template node['pantry']['webapp_template']
    end
end


