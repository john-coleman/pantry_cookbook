default['pantry']['rubygems']['rubygems_host'] = 'http://artifactory.aws.wonga.com/artifactory/api/gems/wonga-rubygems'
default['pantry']['rubygems']['rubygems_key_url'] = "#{node['pantry']['rubygems']['rubygems_host']}/api/v1/api_key.yaml"
default['pantry']['rubygems']['set_push_credentials'] = false
default['pantry']['rubygems']['username'] = nil
default['pantry']['rubygems']['password'] = nil
