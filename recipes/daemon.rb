#
# Cookbook Name:: pantry
# Recipe:: daemon
#
# Copyright 2013, Wonga Technology Ltd.
#
# All rights reserved - Do Not Redistribute
#

include_recipe "git"
include_recipe "runit"
#include_recipe "application"

node['roles'].each do |daemon|
  #if /^pantry*_handler/.match(daemon)
  if /^*_handler/.match(daemon)

    # We pull the ssh private key from the specified users data bag item
    deploy_user_item = data_bag_item('users', node['pantry']['user'])
    app_env = node['pantry']['app_environment']
    app_path = "#{File.expand_path(File.join(deploy_user_item['home'],daemon))}"


    # Get Pantry attributes from specified data bag item if it exists or fall back to attribute
    daemon_revision = data_bag_item(node['pantry']['app_data_bag'], "#{daemon}_revision")['app_revision']
    daemon_config = data_bag_item(node['pantry']['app_data_bag'], daemon)

    gem_package "bundler"

    case app_env
    when "production"
      bundle_args="--deployment --without development test"
    when "test"
      bundle_args="--deployment --without development"
    else
      bundle_args=""
    end

    application "#{daemon}" do
      repository daemon_config['repo']
      owner node['pantry']['user']
      group node['pantry']['group']
      revision daemon_revision unless daemon_revision.nil?
      path app_path
      environment_name app_env
      deploy_key deploy_user_item['ssh_private_key']
      packages daemon_config['packages']
      action :force_deploy

      before_restart do
        directory "#{app_path}/shared/vendor_bundle" do
          owner node['pantry']['user']
          group node['pantry']['group']
          notifies :create, "link[#{app_path}/current/vendor/bundle]", :immediately
          action :create
        end
        link "#{app_path}/current/vendor/bundle" do
          to "#{app_path}/shared/vendor_bundle"
          owner node['pantry']['user']
          group node['pantry']['group']
          subscribes :create, "directory[#{app_path}/shared/vendor_bundle]"
          notifies :run, "execute[#{daemon}_bundle_install]", :immediately
          notifies :restart, "service[#{daemon}]", :delayed
        end
        execute "#{daemon}_bundle_install" do
          command "cd #{app_path}/current && RAILS_ENV=#{app_env} bundle install --path=vendor/bundle #{bundle_args}"
          action :run
          subscribes :run, "link[#{app_path}/current/vendor/bundle]"
        end
        Chef::Log.info "pantry_daemon[#{daemon}] :: deployment starting, rendering init script"
        template "/etc/init.d/#{daemon}" do
          source "daemon_init.erb"
          owner node['pantry']['user']
          group node['pantry']['group']
          mode 0755
          variables(
            :app_environment => app_env,
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
            :aws_access_key_id => daemon_config['aws_access_key_id'],
            :aws_secret_access_key => daemon_config['aws_secret_access_key'],
            :aws_region => node['pantry']['aws_region'],
            :backtrace => daemon_config['backtrace'],
            :daemon_name => daemon_config['id'],
            :dir_mode => daemon_config['dir_mode'],
            :dir => "#{app_path}/shared",
            :error_arn => daemon_config['error_arn'],
            :monitor => daemon_config['monitor'],
            :pantry_api_key => daemon_config['pantry_api_key'],
            :pantry_request_timeout => daemon_config['pantry_request_timeout'],
            :pantry_url => node['pantry']['pantry_url'],
            :queue_name => daemon_config['queue_name'],
            :topic_arn => daemon_config['topic_arn']
          )
          action :create
          notifies :restart, "service[#{daemon}]", :delayed
        end
        Chef::Log.info "pantry_daemon[#{daemon}] :: config rendered, linking it in to this deployment revision"
        link "#{app_path}/current/daemons/#{daemon}/daemon.yml" do
          to "#{app_path}/shared/#{daemon}_daemon.yml"
          owner node['pantry']['user']
          group node['pantry']['group']
          subscribes :create, "template[#{app_path}/shared/#{daemon}_daemon.yml]"
          notifies :restart, "service[#{daemon}]", :delayed
        end
      end
    end
  end
end
