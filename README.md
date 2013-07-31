pantry Cookbook
===============
Deploys and configures the Pantry service and daemons

Requirements
------------
Ubuntu 12.04 LTS
Ruby / RVM
AWS credentials with EC2, SQS and SNS privileges

#### cookbooks
- `application` - for the capistrano-style deployment and callbacks
- `application_ruby` - Ruby rails LWRP extension of application
- `git` - so we can clone the code to deploy
- `runit` - to run services
- `passenger_apache2` - Ruby application server, could use `nginx` with `unicorn` or whatever `application_ruby` supports in the future
- `apache2` - webserver for passenger

#### packages
- `libxml2-dev` - xml (nokogiri?)
- `libxslt1-dev` - xslt (nokogiri?)
- `libmysqlclient-dev` - mysql client (rails mysql2 adapter)
- `libcurl4-openssl-dev` - curl ssl support
- `libpcre3-dev` - regex

Attributes
----------
TODO: List you cookbook attributes here.

e.g.
#### pantry::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['pantry']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### pantry::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `pantry` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[pantry]"
  ]
}
```

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors:
Pantry Team <pantry@example.com>
Alex Slynko <pantry@example.com>
Clive Foley <clive.foley@example.com>
John Coleman <john.coleman@example.com>
Justin Connell <justin.connell@example.com>
Kieran Manning <kieran.manning@example.com>
