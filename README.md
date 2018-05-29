Deploy docker with following command,

docker build -t apachephpssl -f Dockerfile .

docker run -d -p 433:433 --name apachephpssl --hostname apachephpssl apachephpssl

#Use your own certificates adding volume

-v /localhost/apache2ssl:/etc/ssl
