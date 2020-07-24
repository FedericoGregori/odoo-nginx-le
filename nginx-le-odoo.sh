#! /bin/bash

###################################################################################################
#
# Author:       Lucas L. Soto
# Company:      Calyx Servicios S.A.
# License:      AGPL-3
# Description:  Script aims to transform a non-proxied Odoo into a SSL protected one (NGINX + LE).
#
###################################################################################################

# Let’s begin by updating the package lists and installing software-properties-common and NGINX
# Commands separated by && will run in succession.
echo "Updating and installing software-properties-common and NGINX..."
sudo apt-get update && sudo apt-get install software-properties-common nginx -y

# Now add the repositories Universe and Certbot.
echo "Adding Universe and Certbot repositories..."
sudo add-apt-repository ppa:certbot/certbot -y


sudo certbot --nginx --non-interactive --agree-tos -m lsoto@calyxservicios.com.ar

