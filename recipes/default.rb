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

# Setup the knife .chef config directory
directory "#{deploy_user_item['home']}/.chef" do
  owner node['pantry']['user']
  group node['pantry']['group']
  mode 0750
end

# Set up the knife client key
file "#{deploy_user_item['home']}/.chef/#{knife_data['client_name']}.pem" do
  owner node['pantry']['user']
  group node['pantry']['group']
  mode 0640
  content knife_data['client_key']
  action :create
end

# Set up the SSH key
file "#{deploy_user_item['home']}/.chef/aws-ssh-keypair.pem" do
  owner node['pantry']['user']
  group node['pantry']['group']
  mode 0600
  content knife_data['aws_key']
  action :create
end

# Set up the knife client config
template "#{deploy_user_item['home']}/.chef/knife.rb" do
  source "knife.rb.erb"
  owner node['pantry']['user']
  group node['pantry']['group']
  mode 0640
  variables(
    :chef_server => knife_data['chef_server'],
    :client_name => knife_data['client_name']
  )
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
    node['pantry']['daemons'].each do |daemon|
      Chef::Log.info "pantry_daemon[#{daemon}] :: deployment starting"
      begin
        daemon_data_bag_item = data_bag_item(node['pantry']['app_data_bag'], daemon)
        Chef::Log.info "pantry_daemon[#{daemon}] :: data bag found, rendering init script"
        template "/etc/init.d/#{daemon}" do
          source "daemon_init.erb"
          owner node['pantry']['user']
          group node['pantry']['group']
          mode 0755
          variables(
            :daemon => "#{daemon}",
            :daemon_path => "#{app_path}/current/daemons/#{daemon}",
            :user => node['pantry']['user']
          )
          action :create
        end
        Chef::Log.info "pantry_daemon[#{daemon}] :: init script rendered, enabling service"
        service "#{daemon}" do
          action :enable
          supports :start => true, :stop => true, :restart => true, :status => true, :reload => true
        end
        Chef::Log.info "pantry_daemon[#{daemon}] :: service enabled, rendering config"
        template "#{app_path}/shared/#{daemon}_daemon.yml" do
          local true
          source File.join(app_path,"current","daemons","config","daemon.yml.erb")
          owner node['pantry']['user']
          group node['pantry']['group']
          mode 0640
          variables(
            :app_environment => app_env,
            :aws_access_key_id => daemon_data_bag_item['aws_access_key_id'],
            :aws_secret_access_key => daemon_data_bag_item['aws_secret_access_key'],
            :aws_region => daemon_data_bag_item['aws_region'],
            :backtrace => daemon_data_bag_item['backtrace'],
            :daemon_name => daemon_data_bag_item['id'],
            :dir_mode => daemon_data_bag_item['dir_mode'],
            :dir => "#{app_path}/shared",
            :error_arn => daemon_data_bag_item['error_arn'],
            :monitor => daemon_data_bag_item['monitor'],
            :pantry_api_key => daemon_data_bag_item['pantry_api_key'],
            :pantry_request_timeout => daemon_data_bag_item['pantry_request_timeout'],
            :pantry_url => node['pantry']['pantry_url'],
            :queue_name => daemon_data_bag_item['queue_name'],
            :topic_arn => daemon_data_bag_item['topic_arn']
          )
          action :create
          notifies :restart, "service[#{daemon}]", :delayed
        end
        Chef::Log.info "pantry_daemon[#{daemon}] :: config rendered, linking it in to this deployment revision"
        link "#{app_path}/current/daemons/#{daemon}/daemon.yml" do
          to "#{app_path}/shared/#{daemon}_daemon.yml"
          owner node['pantry']['user']
          group node['pantry']['group']
          notifies :restart, "service[#{daemon}]", :delayed
        end
      rescue => e
        Chef::Log.error "pantry_daemon[#{daemon}] :: deployment failed: #{e}"
      end
    end
  end

  passenger_apache2 do
    server_aliases node['pantry']['server_aliases']
    webapp_template node['pantry']['webapp_template']
  end
end

