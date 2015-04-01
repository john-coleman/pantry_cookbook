# CHANGELOG for pantry

This file is used to list changes made in each version of pantry cookbook.

## 0.4.4
* Fixed default recipe

## 0.4.3
* Added test kitchen

## 0.4.2
* Big cleaning of cookbook

## 0.4.1
* Added seeding for database

## 0.4.0
* Fixed recipe for installing gems from custom source
* Fixed all failing tests, rubocop and foodcritic warnings

## 0.3.6
* Added rbenv
* Save credentials for gem source

## 0.3.5
* Moved database & user creation in separate recipe

## 0.3.4
* Fixed pantry deployment

## 0.3.3

* Use mysql-chef_gem instead of installing mysql gem
* Freeze application_ruby

## 0.3.2

* Update Berkshelf version
* Update mysql cookbook
* Install mysql gem manually

## 0.3.1

* Use pantry_url in pantry_deployment

## 0.3.0

* Reverted multiple daemons run
* Added cookbook for creating generic user_groups

## 0.2.0

* Allow to start daemon multiple times

## 0.1.11

* Enabled HTTPS support for Pantry
* Emphasized some attributes are to be specified in Data Bag items

## 0.1.10

* Pantry config now passed as block to template

## 0.1.9

* Use ssh-util for make settings for ssh-config
* Introduced Berkshelf

## 0.1.8

* Updating apache vhost template for Rails3 RackBaseURI directive

## 0.1.7

* Daemon data bag item raw data is now passed through to the template allowing data-driven config
* Git app_revision merged to each daemon's data bag item

## 0.1.6

* Added daemons recipe using role names and data bag items to deploy a given daemon
* Moved pantry user's knife configuration to a separate recipe, also driven by data bag

## 0.1.5

* Added precompile assets
* Added nodejs
* Added webkit & xvfb for tests

## 0.1.4

* Adds before_restart callback to restart the delayed_jobs process during a new deployment

## 0.1.3

* Added Chef API credentials from a data bag item with fallback to attributes

## 0.1.2:

* Pantry revision can be specified in a data bag with fallback to an attribute
* Removed some redundant attributes (deploy_port, deploy_pid)
* Renamed some attributes (deploy_revision -> app_revision etc.)

## 0.1.1:

* Apache2 and Passenger app server instead of Rails Webrick. Nginx + Unicorn support to be added in future releases.

## 0.1.0:

* Initial release of pantry

- - -
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.
