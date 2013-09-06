default['pantry']['app_data_bag'] = "pantry"
default['pantry']['app_data_bag_item'] = "pantry"
default['pantry']['app_environment'] = "test"
default['pantry']['app_migrate'] = true
default['pantry']['app_path'] = "/home/pantry/pantry"
default['pantry']['app_revision'] = "HEAD"

default['pantry']['aws_region'] = "eu-west-1"

default['pantry']['chef']['client_key'] = "pantry_client_key_default_attribute"
default['pantry']['chef']['client_name'] = "pantry_client_name_default_attribute"
default['pantry']['chef']['chef_server'] = "https://pantry.chef-server.default-attribute"
default['pantry']['chef_data_bag'] = "pantry"
default['pantry']['chef_data_bag_item'] = "pantry_knife"

default['pantry']['database_adapter'] = "mysql2"
default['pantry']['database_host'] = "localhost"
default['pantry']['database_master_role'] = "pantry"
default['pantry']['database_name'] = "pantry"
default['pantry']['database_username'] = "pantry"
default['pantry']['database_password'] = "pantry"

default['pantry']['repo'] = "git@github.com:wongatech/pantry.git"
default['pantry']['group'] = "pantry"
default['pantry']['user'] = "pantry"
default['pantry']['server_aliases'] = [ "pantry" ]
default['pantry']['pantry_url'] = "http://pantry"
default['pantry']['webapp_template'] = "pantry_apache.conf.erb"

default['pantry']['nodejs_package'] = "nodejs"
default['pantry']['ssh_configs'] = []

default['pantry']['omniauth']['title'] = "Pantry LDAP Login"
default['pantry']['omniauth']['host'] = "ldap.example.com"
default['pantry']['omniauth']['port'] = 3268
default['pantry']['omniauth']['method'] = "plain"
default['pantry']['omniauth']['base'] = "dc=example,dc=com"
default['pantry']['omniauth']['uid'] = "sAMAccountName"
default['pantry']['omniauth']['bind_dn'] = "your_user@example.com"
default['pantry']['omniauth']['password'] = "secret_password"
default['pantry']['omniauth']['auth_method'] = "simple"
default['pantry']['aws']['queue_name'] = "pantry_example_com-ec2_boot_command"
default['pantry']["aws"]["access_key_id"] = 'AKIEXAMPLEACCESSKEYZ'
default['pantry']["aws"]["secret_access_key"] = "your_secret_access_key"
default['pantry']["aws"]["region"] = "eu-west-1"
default['pantry']["aws"]["billing_bucket"] = "pantry-billing_development"
default['pantry']["aws"]["vpc_id"] = "vpc-00110011"
default['pantry']["aws"]["security_group_windows"] = "sg-00110011"
default['pantry']["aws"]["security_group_linux"] = "sg-00110010"
default['pantry']["aws"]["security_group_jenkins"] = "sg-00110012"
default['pantry']["aws"]["key_pair_name"] = "aws-ssh-keypair"
default['pantry']["aws"]["http_proxy"] = "http://proxy.example.com:8080"
default['pantry']["aws"]["windows_admin_password"] = "LocalAdminPassword"
default['pantry']["aws"]["jenkins_flavor"] = "t1.micro"
default['pantry']["aws"]["jenkins_windows_ami"] = "ami-00110011"
default['pantry']["aws"]["jenkins_linux_ami"] = "ami-00110010"
default['pantry']["aws"]["jenkins_linux_server_role"] = "role[jenkins_linux_server]"
default['pantry']["aws"]["jenkins_windows_agent_role"] = "role[jenkins_windows_agent]"
default['pantry']['aws']['default_subnet'] = "subnet-00110011"

default['pantry']['pantry']['domain'] = "example.com"
default['pantry']['pantry']['default_ou'] = "OU=Computers,DC=wonga,DC=aws"
default['pantry']['pantry']['api_key'] = "00110011-0011-0011-0011-001100110011"