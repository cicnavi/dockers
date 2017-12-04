
U PowerShellu:
docker run --name test -v $PWD/src:/var/www/src -v $PWD/html:/var/www/html -p 8080:80 cicnavi/test:1

Treba još dodati instalaciju mcrypt i pdo_mysql



# dodao u hosts

127.0.0.10 web71.dev

https://stackoverflow.com/questions/8652948/using-port-number-in-windows-host-file
netsh interface portproxy add v4tov4 listenport=80 listenaddress=127.0.0.10 connectport=8080 connectaddress=127.0.0.1

netsh interface portproxy show v4tov4

You can remove the entry with the following command:

netsh interface portproxy delete v4tov4 listenport=80 listenaddress=127.65.43.21

docker update --restart=unless-stopped <yourContainerID_or_Name>