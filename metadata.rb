name             'pantry'
maintainer       'Wonga Technology Ltd.'
maintainer_email 'pantry@example.com'
license          'All rights reserved'
description      'Installs/Configures Pantry services'
long_description IO.read(File.join(File.dirname(__FILE__),'README.md'))
version          '0.4.4'

depends "application"
depends "application_ruby"
depends "git"
depends "passenger_apache2"
depends "runit"
depends 'database', '~> 2.0'
depends 'mysql', '~> 5.0'
depends 'rbenv'
depends 'ssh-util'
depends 'users'
