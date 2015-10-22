pantry Cookbook
===============
Deploys and configures the Pantry service and daemons

## Recipes

### Global attributes

Almost everything is done for user with selected group and username

* `node['pantry']['user']`
* `node['pantry']['group']`

### pantry::rubygems

Adds custom rubygems repo to bundle sources. Uses simple auth to connect to remote repo.
If gem push is enabled, downloads credentials and sets RUBYGEMS_HOST.

#### Attributes
* `node['pantry']['rubygems']['rubygems_host']` - alternative RubyGems host. Default to artifactory
* `node['pantry']['rubygems']['rubygems_key_url']` - address to get key from remote repo. Default to false.
* `node['pantry']['rubygems']['set_push_credentials']` - if true, allows push from given host to RubyGems
* `node['pantry']['rubygems']['username']` - username for auth on remote RubyGems site.
* `node['pantry']['rubygems']['password']` - password for auth on remote RubyGems site.

Contributing
------------
1. Clone the repository from [Github](https://github.com/wongatech/wonga_pantry_cookbook)
2. Create a named feature branch with JIRA ticket (like `TD-1234_Adds_Feature_X`)
3. Write your change
4. Add section in README.md how to use your recipe
5. Add small description in CHANGELOG.md and change metadata.rb
6. Write [chefspec](http://docs.getchef.com/chefspec.html) and [serverspec](http://serverspec.org/resource_types.html) tests for your change (if applicable)
7. Run tests eg. `rake`,`test-kitchen test -c 4`, ensuring they all pass
8. Write [a meaningful git commit message](https://xkcd.com/1296/) including the JIRA ticket ID and a synopsis of changes if needed
9. Run `git rebase -i`, squash your commits, retain the original Change-ID and re-run tests if you've been lone-wolfing too long
10. Run `git review` to submit a Change Request ID and link it to JIRA

License and Authors
-------------------
* Author: Pantry Team (<pantry@wonga.com>)
* Author: Aleksey Dragan (<aleksey.dragan@wonga.com>)
* Author: Alex Slynko (<alex.slynko@wonga.com>)
* Author: John Coleman (<john.coleman@wonga.com>)
* Author: Justin Connell (<justin.connell@wonga.com>)
* Author: Kieran Manning (<kieran.manning@wonga.com>)
* Author: Riccardo Tacconi (<riccardo.tacconi@wonga.com>)
