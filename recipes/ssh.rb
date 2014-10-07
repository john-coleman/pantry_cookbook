#
# Cookbook Name:: pantry
# Recipe:: ssh
#
# Copyright 2013, Wonga Technology Ltd.
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'ssh-util'

node['pantry']['ssh_configs'].each do |config|
  options = config.select { |k, v| %w(User IdentityFile StrictHostKeyChecking).include?(k) && !v.nil? }

  ssh_util_config config['host'] do
    options options
    user config['user']
  end
end
