#!/usr/bin/env bash
# sets up the web servers for the deployment of web_static

sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install nginx
sudo mkdir -p /data/web_static/releases/test /data/web_static/shared
echo "<html>
  <head>
  </head>
  <body>
    Holberton School
  </body>
</html>" | sudo tee /data/web_static/releases/test/index.html
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current
sudo chown -hR ubuntu:ubuntu /data/
sudo sed -i '12i\\s\s\s\slocation /hbnb_static/ {\n\s\s\s\s\s\s\s\salias /data/web_static/current/;\n\s\s\s\s}\n' /etc/nginx/sites-available/default
sudo service nginx start
