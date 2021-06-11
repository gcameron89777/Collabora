# Collabora CODE

The purpose of this repo is to provide a [Collabora CODE ("Collabora Online Development Edition")](https://www.collaboraoffice.com/code/) server via Docker for use with [Nextcloud](https://nextcloud.com/). Collabora CODE allows for online editing of libre office documents such as ods (spreadsheets) or odt (word editing).

Collabora CODE is accessed by Nextcloud via a url in the settings.

# What this repo does

This repo draws heavily from [nginx and certbot](https://github.com/wmnnd/nginx-certbot) repo to obtain a SSL certificate from [Letsencrypt](https://letsencrypt.org/) that automatically renews. This SSL certificate is then applied to the domain mentioned above for use with Collabora CODE.

# Prerequisites

To use this repo you will need a server running docker and docker compose and a domain name that is pointed to the server.

# Instructions

1. Add the .env file and variables within (See the first sentence at the end of this list).
2. Copy the files to your server, including docker-compose.yml, init-letsencrypt.sh, entry-scripts/40-reload.sh and templates/default.conf.template.
3. Run the init script `./init-letsencrypt.sh` to obtain your initial Lets Encrypt certificate. After this script runs you should see various output in the terminal confirming the obtainment of the certificate. For fuller details see the [repo highlighted above that I drew on to create this set up](https://github.com/wmnnd/nginx-certbot).
4. The init-letsencrypt.sh script should leave two docker services running, nginx and collabora. Verify with `docker ps`, you should see the two services running.
5. Run the certbot service for auto renewal with `docker-compose up -d certbot`. You should now see 3 services running with `docker ps`.
6. Visit https://[your domain] in your browser and you should see the OK message.
7. Paste your url including the https protocol in Nextcloud > Settings > Collabora Online Development Edition > Use your own server > URL input field. When you hit save you should see a green button and message 'Collabora online server is reachable'


A file missing from the repo is the .env file which contains the following personalized settings. If you clone this repo, then create a .env file, add it to root and include the following 3 variables:

_Escape dots with backslashes in the NEXTCLOUD_DOMAIN variable, e.g. if you use Hetzner for a turnkey Nextcloud instance with their storage share plan, this variable will look something like this: nx12345\\.your-storageshare\\.de_

 * NEXTCLOUD_DOMAIN=[the domain of your nextcloud instance]
 * COLLABORA_DOMAIN=[your domain for use with collabora]
 * EMAIL=[The email address to use to obtain the Let's Encrypt certificate] # optional

# How it works

This repo uses [nginx envsubst](https://github.com/docker-library/docs/tree/master/nginx#using-environment-variables-in-nginx-configuration-new-in-119) to read the variables in .env (step 1 above) and to then populate the nginx conf file to set up a server and redirects with the SSL certificate. 

The file `entry-scripts/40-reload.sh` is added to docker-entrypoint.d directory on the nginx container. Shell files in this directory are run automatically before nginx starts (this is where envsubst is done). 

The file `40-reload.sh` reloads nginx every minute in case a newly renewed certificate has been pulled. 

File `templates/default.conf.template` is the nginx conf file that contains variable placeholders for the domain name which is sourced from the .env during envsubst. This file configures the nginx server as well as redirects from http to https.




