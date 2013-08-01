#
# Cookbook Name:: pantry
# Recipe:: default
#
# Copyright 2013, Wonga Technology Ltd.
#
# All rights reserved - Do Not Redistribute
#

# We pull the ssh private key from the specified users data bag item
deploy_user_item = data_bag_item('users', node['pantry']['user'])

# Get Pantry Chef credentials from specified data bag item if it exists of fall back to attributes
begin
  chef_data_bag_item = data_bag_item(node['pantry']['chef_data_bag'], node['pantry']['chef_data_bag_item'])
  knife_data = chef_data_bag_item['chef']
rescue
  Chef::Log.warn "Data Bag #{node['pantry']['chef_data_bag']} does not exist, falling back to attribute"
  knife_data = node['pantry']['chef']
end

Chef::Log.info "#########################################"
Chef::Log.info "DEPLOYING pantry_knife"
Chef::Log.info "#########################################"

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

# Set up the knife validation key
file "#{deploy_user_item['home']}/.chef/#{knife_data['validation_name']}.pem" do
  owner node['pantry']['user']
  group node['pantry']['group']
  mode 0640
  content knife_data['validation_key']
  action :create
end

# Set up the SSH key
file "#{deploy_user_item['home']}/.ssh/aws-ssh-keypair.pem" do
  owner node['pantry']['user']
  group node['pantry']['group']
  mode 0600
  content chef_data_bag_item['aws_key']
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
    :client_name => knife_data['client_name'],
    :validation_key => "#{deploy_user_item['home']}/.chef/#{knife_data['validation_client_name']}.pem",
    :validation_client_name => knife_data['validation_client_name']
  )
  action :create
end

