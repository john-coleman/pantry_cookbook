#
# Cookbook Name:: pantry
# Recipe:: users
#
# Copyright 2014, Wonga Technology Ltd.
#
# All rights reserved - Do Not Redistribute
#

if node['authorization']['groups']
  node['authorization']['groups'].each do |group|
    users_manage group['name'] do
      group_id group['id']
      action [:remove, :create]
    end
  end
end
