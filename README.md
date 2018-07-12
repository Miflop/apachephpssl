# Build & Deploy docker with following command,

docker build -t apachephpssl -f Dockerfile .

docker run -d -p 433:433 --name apachephpssl --hostname apachephpssl apachephpssl

# Deploy directly from docker hub with certs & server storage & linked mariadb container

sudo docker run -d --privileged --restart=unless-stopped --link mariadb --name apachephpssl -p 443:443 -v /serverdirectory/mycerts:/etc/ssl -v /serverdirectory/mypages:/var/www/html miflop/apachephpssl

# Use your own certificates adding volume

-v /serverdirectory/mycerts:/etc/ssl

# Use server directory to store your pages

-v /serverdirectory:/var/www/html
