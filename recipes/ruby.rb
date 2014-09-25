include_recipe 'rbenv'
include_recipe 'rbenv::rbenv_vars'
include_recipe 'rbenv::ruby_build'

rbenv_ruby node['ruby']['version'] do
  global true
end

rbenv_gem 'bundler' do
  ruby_version node['ruby']['version']
end

node.set['language']['ruby']['ruby_bin'] = '/opt/rbenv/shims/ruby'
