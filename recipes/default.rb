#
# Cookbook Name:: pantry
# Recipe:: default
#
# Copyright 2013, Wonga Technology Ltd.
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'git'
include_recipe 'runit'
include_recipe 'passenger_apache2'
include_recipe 'pantry::database'

package node['pantry']['nodejs_package']

# We pull the ssh private key from the specified users data bag item
deploy_user_item = data_bag_item('users', node['pantry']['user'])
app_env = node['pantry']['app_environment']
app_path = node['pantry']['app_path']

# Get Pantry attributes from specified data bag item if it exists or fall back to attribute
app_data_bag_item = data_bag_item(node['pantry']['app_data_bag'], node['pantry']['app_data_bag_item'])
pantry_config = app_data_bag_item.raw_data

app_revision = pantry_config['app_revision']

Chef::Log.info '#########################################'
Chef::Log.info "DEPLOYING PANTRY REVISION #{app_revision}"
Chef::Log.info '#########################################'

# rails database sub-resource can't access node attributes directly.
db_adapter = node['pantry']['database_adapter']
db_database = node['pantry']['database_name']
db_username = node['pantry']['database_username']
db_password = node['pantry']['database_password']

if pantry_config['webapp']['ssl_enabled']
  file "/etc/ssl/certs/#{pantry_config['webapp']['ssl_ca_cert_name']}" do
    content pantry_config['webapp']['ssl_ca_cert']
    owner 'root'
    group 'ssl-cert'
    mode 0644
  end

  execute 'ssl_ca_cert_rehash' do
    command 'c_rehash'
    subscribes :create, "file[/etc/ssl/certs/#{pantry_config['webapp']['ssl_ca_cert_name']}", :immediately
  end

  file "/etc/ssl/certs/#{pantry_config['webapp']['ssl_cert_name']}" do
    content pantry_config['webapp']['ssl_cert']
    owner 'root'
    group 'ssl-cert'
    mode 0644
  end

  file "/etc/ssl/private/#{pantry_config['webapp']['ssl_key_name']}" do
    content pantry_config['webapp']['ssl_key']
    owner 'root'
    group 'root'
    mode 0600
  end
end

application 'pantry' do
  repository node['pantry']['repo']
  owner node['pantry']['user']
  group node['pantry']['group']
  revision app_revision unless app_revision.nil?
  path app_path
  environment_name app_env
  migrate node['pantry']['app_migrate']
  deploy_key deploy_user_item['ssh_private_key']
  packages ['libxml2-dev', 'libxslt1-dev', 'libmysqlclient-dev', 'libcurl4-openssl-dev', 'libpcre3-dev']
  action :force_deploy

  rails do
    precompile_assets app_env == 'production'
    gems %w(bundler passenger unicorn)
    database_master_role node['pantry']['database_master_role']
    database do
      adapter db_adapter
      database db_database
      username db_username
      password db_password
    end
  end

  before_migrate do
    template "#{app_path}/shared/aws.yml" do
      local true
      source File.join(release_path, 'config', 'aws.yml.erb')
      variables(
        app_environment: app_env,
        config: pantry_config
      )
      owner node['pantry']['user']
      group node['pantry']['group']
      mode 0644
      action :create
    end

    Chef::Log.info 'pantry :: aws.yml rendered, linking it in to this deployment revision'

    link "#{release_path}/config/aws.yml" do
      to "#{app_path}/shared/aws.yml"
      owner node['pantry']['user']
      group node['pantry']['group']
      subscribes :create, "template[#{app_path}/shared/aws.yml]"
    end

    template "#{app_path}/shared/pantry.yml" do
      local true
      source File.join(release_path, 'config', 'pantry.yml.erb')
      variables(
        app_environment: app_env,
        config: pantry_config,
        pantry_url: node['pantry']['pantry_url']
      )
      owner node['pantry']['user']
      group node['pantry']['group']
      mode 0644
      action :create
    end

    Chef::Log.info 'pantry :: pantry.yml rendered, linking it in to this deployment revision'

    link "#{release_path}/config/pantry.yml" do
      to "#{app_path}/shared/pantry.yml"
      owner node['pantry']['user']
      group node['pantry']['group']
      subscribes :create, "template[#{app_path}/shared/pantry.yml]"
    end

    template "#{app_path}/shared/newrelic.yml" do
      local true
      source File.join(release_path, 'config', 'newrelic.yml.erb')
      variables(
        app_environment: app_env,
        config: pantry_config
      )
      owner node['pantry']['user']
      group node['pantry']['group']
      mode 0644
      action :create
    end

    Chef::Log.info 'pantry :: newrelic.yml rendered, linking it in to this deployment revision'

    link "#{release_path}/config/newrelic.yml" do
      to "#{app_path}/shared/newrelic.yml"
      owner node['pantry']['user']
      group node['pantry']['group']
      subscribes :create, "template[#{app_path}/shared/newrelic.yml]"
    end
  end

  before_restart do
    Chef::Log.info '#########################################'
    Chef::Log.info "RESTARTING PANTRY REVISION #{app_revision}"
    Chef::Log.info '#########################################'
  end

  passenger_apache2 do
    server_aliases node['pantry']['server_aliases']
    webapp_template node['pantry']['webapp']['template']
    params pantry_config
  end
end
