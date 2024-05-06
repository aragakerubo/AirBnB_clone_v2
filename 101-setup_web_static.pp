# Script that sets up your web servers for the deployment of web_static.
# Define a class for web server setup
class webserver {

  # Install Nginx package
  package { 'nginx': ensure => installed }

  # Create directories with ownership
  file { [
    '/data',
    '/data/web_static',
    '/data/web_static/releases',
    '/data/web_static/shared',
  ]:
    ensure => directory,
    owner => 'ubuntu',
    group => 'ubuntu',
    mode => '0755',
  }

  # Create test release directory and index.html
  file { '/data/web_static/releases/test/index.html':
    ensure => file,
    content => "<!DOCTYPE html><html><body><h1>Welcome to hbnb_static</h1></body></html>",
  }

  # Configure Nginx
  file { '/etc/nginx/sites-available/hbnb_static':
    ensure => file,
    source => 'templates/hbnb_static.conf.erb',
  }

  # Include template for Nginx configuration
  file { 'templates/hbnb_static.conf.erb':
    ensure => present,
    source => '/path/to/your/hbnb_static.conf.erb',  # Replace with actual template path
  }

  # Service definition for Nginx
  service { 'nginx':
    ensure => running,
    enable => true,
  }
}

# Apply the class to the node (assuming this manifest is included in a site.pp)
node default {
  include webserver
}
