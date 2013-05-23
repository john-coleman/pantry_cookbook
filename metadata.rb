name             'pantry'
maintainer       'Wonga Technology Ltd.'
maintainer_email 'pantry@example.com'
license          'All rights reserved'
description      'Installs/Configures Pantry service'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.3'
depends "application"
depends "application_ruby"
depends "git"
depends "runit"
depends "passenger_apache2"
