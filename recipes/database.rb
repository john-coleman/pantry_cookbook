mysql_client('default').run_action(:create)

gem_package 'mysql' do
  gem_binary RbConfig::CONFIG['bindir'] + '/gem'
end.run_action(:install)
# rails database sub-resource can't access node attributes directly.
db_database = node['pantry']['database_name']
db_username = node['pantry']['database_username']
db_password = node['pantry']['database_password']

# Create the database and user
mysql_connection_info = { host: 'localhost',
                          username: 'root',
                          password: node['mysql']['server_root_password'] }

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
