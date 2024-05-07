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

  # Configure Nginx site for static content
  file { '/etc/nginx/sites-available/default':
    ensure => file,
    content => "server {
        listen 80;
        listen [::]:80 default_server;
        add_header X-Served-By 404031-web-01;

        location /hbnb_static/ {
            alias /data/web_static/current/;
        }


        root   /var/www/html/;
        index  index.html index.htm;

        location /redirect_me {
            return 301 https://www.youtube.com/watch?v=QH2-TGUlwu4;
        }


        error_page 404 /404.html;
        location /404 {
            root /var/www/html/;
            internal;
        }

    }",
  }

  # Create symbolic link to current release
  file { '/data/web_static/current':
    ensure => link,
    target => '/data/web_static/releases/test',
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
