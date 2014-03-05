name             'pantry'
maintainer       'Wonga Technology Ltd.'
maintainer_email 'pantry@example.com'
license          'All rights reserved'
description      'Installs/Configures Pantry services'
long_description IO.read(File.join(File.dirname(__FILE__),'README.md'))
version          '0.3.0'
depends "application"
depends "application_ruby"
depends "git"
depends "runit"
depends "passenger_apache2"
depends 'ssh-util'
depends 'mysql'
depends 'database'
depends 'users'
