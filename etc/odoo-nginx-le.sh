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
sudo apt-get update && sudo apt-get install software-properties-common nginx wget

# Now add the repositories Universe and Certbot.
sudo add-apt-repository universe && sudo add-apt-repository ppa:certbot/certbot

# Go to NGINX sites-* path and delete all. After that, create a dummy server.
cd /etc/nginx/sites-enabled/ && sudo rm -R *
cd /etc/nginx/sites-available/ && sudo rm -R *
wget https://gist.githubusercontent.com/sotolucas/1a14203bcf6c82c0cd9310d2afe7c70f/raw/df6333abcb54422cce52b0090d543a179f6970e8/foo-bar.calyx-cloud.com.ar

sudo certbot --nginx --non-interactive --agree-tos -m lsoto@calyxservicios.com.ar

