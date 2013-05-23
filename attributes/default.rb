default['pantry']['app_data_bag'] = "pantry"
default['pantry']['app_data_bag_item'] = "pantry"
default['pantry']['app_environment'] = "test"
default['pantry']['app_path'] = "/home/pantry/pantry"
default['pantry']['app_revision'] = "HEAD"

default['pantry']['chef']['client_key'] = "pantry_client_key_default_attribute"
default['pantry']['chef']['client_name'] = "pantry_client_name_default_attribute"
default['pantry']['chef']['chef_server'] = "https://pantry.chef-server.default-attribute"
default['pantry']['chef_data_bag'] = "pantry"
default['pantry']['chef_data_bag_item'] = "pantry_knife"

default['pantry']['database_adapter'] = "mysql2"
default['pantry']['database_master_role'] = "wonga_linux_pantry_server"
default['pantry']['database_name'] = "pantry"
default['pantry']['database_username'] = "pantry"
default['pantry']['database_password'] = "pantry"

default['pantry']['repo'] = "git@github.com:wongatech/pantry.git"
default['pantry']['group'] = "pantry"
default['pantry']['user'] = "pantry"
default['pantry']['server_aliases'] = [ "pantry" ]
default['pantry']['webapp_template'] = "pantry_apache.conf.erb"
