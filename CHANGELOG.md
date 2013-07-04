# CHANGELOG for pantry

This file is used to list changes made in each version of pantry.

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
