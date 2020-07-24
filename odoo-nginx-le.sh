#! /bin/bash

###################################################################################################
#
# Author:       Lucas L. Soto
# Company:      Calyx Servicios S.A.
# License:      AGPL-3
# Description:  Script aims to transform a non-proxied Odoo into a SSL protected one (NGINX + LE).
#
###################################################################################################

# Now add the repositories Certbot.
echo "Adding Certbot repositories..."
sudo add-apt-repository ppa:certbot/certbot -y

# Let’s begin by updating the package lists and installing software-properties-common and NGINX.
# Commands separated by && will run in succession.
echo "Updating and installing software-properties-common and NGINX..."
sudo apt-get update && sudo apt-get install software-properties-common nginx python-certbot-nginx -y

# Go to NGINX sites-* path and delete all. After that, create a dummy server for ACME challenge.
echo "Removing default NGINX servers and creating server for ACME challenge..."
cd /etc/nginx/sites-enabled/ && sudo rm default
cd /etc/nginx/sites-available/ && sudo rm default
sudo wget -O odoo https://raw.githubusercontent.com/sotolucas/odoo-nginx-le/master/etc/nginx/sites-available/no-ssl && sudo ln -s /etc/nginx/sites-available/odoo /etc/nginx/sites-enabled/odoo

# Ask user to input domains.
read -p "Ingrese el dominio principal: " PRI_DOM
read -p "Ingrese los dominios secundarios: " SEC_DOM
ALL_DOM=$PRI_DOM' '$SEC_DOM
# Replace example domain with domains provided by user.
echo "Replacing example domain with domains provided by user..."
sudo sed -i "s/foo-bar.calyx-cloud.com.ar/$ALL_DOM/g" odoo

# Restart NGINX server.
echo "Restarting NGINX..."
sudo service nginx restart

# Issue SSL Let's Encrypt! certificate.
echo "Issuing SSL Let's Encrypt! certificate..."
sudo certbot --nginx --non-interactive --agree-tos -m lsoto@calyxservicios.com.ar

# Go to NGINX sites-* path and delete all. After that, create definitive server.
echo "Removing ACME challenge NGINX servers and creating server for Odoo..."
cd /etc/nginx/sites-enabled/ && sudo rm odoo
cd /etc/nginx/sites-available/ && sudo rm odoo
sudo wget -O odoo https://raw.githubusercontent.com/sotolucas/odoo-nginx-le/master/etc/nginx/sites-available/wh-ssl && sudo ln -s /etc/nginx/sites-available/odoo /etc/nginx/sites-enabled/odoo

# Make this in to parts as replacing all foo-bar with ALL_DOM would add it to LE certs path, so...
# First replace example server name for all domains that we need to listen to.
# Then, replace example server name for main domain which is also certificate's main domain.
sudo sed -i "s/server_name foo-bar.calyx-cloud.com.ar/$ALL_DOM/g" odoo
sudo sed -i "s/foo-bar.calyx-cloud.com.ar/$PRI_DOM/g" odoo

# Restart NGINX server.
echo "Restarting NGINX..."
sudo service nginx restart

