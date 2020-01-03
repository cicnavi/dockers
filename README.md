# cicnavi Docker Containers

These are Docker specifications that I use in my day to day work.
You are free to clone this repo and run them as you wish.

```shell
git clone https://github.com/cicnavi/dockers.git dockers
```

To run containers you have to have Docker installed on your system.

## Available containers

- DAP (Debian Apache PHP), references MySQL
- OpenLDAP and phpLDAPadmin (pure osixia/openldap, no customizations)

To run all mentioned containers, once you've cloned this repo, go to 'dockers' directory:

```shell
cd dockers
```

Here you'll find a 'docker-compose.yml' file. This means you can use 'docker-compose' command to easily run defined 
containers (you can edit that file to suit your needs if you wish):

```shell
docker-compose up -d
```

If you look at the 'dockers/docker-compose.yml' file, you'll notice that it actually extends other docker-compose.yml 
files from 'dap' and 'openldap' directories. This way we have a separate configuration if we wish to run all containers, 
or if we only wish to run 'DAP' containers, or if we only wish to run 'OpenLDAP' containers, etc. 

### DAP (Debian Apache PHP) Containers

DAP contaners are available with different PHP versions. Each folder in 'dap' folder coresponds to specific PHP version 
which is used in a container. So, with this approach we can easily run different containers to test our web application 
on different PHP version.

#### Running DAP containers
Once you've cloned this repo, go to 'dap' directory:

```shell
cd dockers/dap
```

Here you'll find a 'docker-compose.yml' file. This means you can use 'docker-compose' command to easily run defined 
containers (you can edit that file to suit your needs if you wish):

```shell
docker-compose up -d
```

If you look at the 'docker-compose.yml' file, you'll notice that besides DAP containers, it will also run a MySQL 
container. This is because I often use MySQL as a database, so this way I have it available instantly. Feel free to 
delete MySQL part if you don't plan to use it in your work.

#### Configuring Apache and PHP
Inside 'dap' folder, there is one folder for each PHP version. For each PHP version we can set custom Apache and PHP 
configuration. 

Apache configuration can be set by creating files ending in '.conf' in 'apache-config' folder.

PHP configuration can be set in 'php.ini' file which is available in 'php-config' folder.

#### Setting source files for your web application
In each PHP version folder, you will find folders 'src' and 'html'. Folder 'src' should contain your web application 
source files, while the 'html' folder should contain files which will be served publicly by the Apache web server. 
By default, in 'html' folder you'll find 'index.php' file which will dump PHP information.

When you put application source files in 'src' folder, you can enter the 'bash' in the container, and create a symlink 
to the application source which will be served publicly.

For example, let's enter the 'bash' in '72.dap.test' container:
```shell
docker exec -it 72.dap.test bash
```
By default, you'll be positioned in '/var/www/html' folder. Here you can create a symlink to a source file or folder 
you whish to be serverd by Apache:
```shell
ln -s ../src/some-php-app/public some-php-app
```
This will create a symbolic link 'some-php-app' which will point to 'public' folder of our PHP application. Of course, 
you should adjust symlinks to suit your needs.

#### Running web application
If you look at the 'docker-compose.yml' file, you'll find port specifications for different containers. By default, 
container which has PHP version 7.0 will use port 8070. Container with PHP version 7.1 will use port 8071, and so on.

This means that we can now access our web application on localhost URL by specifing the right port for the container. 
For example, since we deployed our app to container 72.dap.test, we can use port 8072 to open it in browser: 
http://localhost:8072/some-php-app/.

If you only enter http://localhost:8072, you'll get PHP info dump.

#### Specifying container host names and forwarding ports
You can edit your hosts file and add host names for each container.
For example, you can add the following entries:
```
127.0.0.56 56.dap.test
127.0.0.71 71.dap.test
127.0.0.72 72.dap.test
127.0.0.73 73.dap.test
127.0.0.74 74.dap.test
127.0.0.100 mysql.dap.test
```
Note that we specify different IP for different host. This way you can enter URL for the container like this: 
http://72.dap.test:8072. However, notice that we still have to enter the port of the container, so we didn't get to 
far yet. We want to only enter hostname for the container. To do that we need to forward specific ports on specific 
IP addresses, to other ports. 

So, we want to forward port 80 on specific IP address to specific port used on the container. Let's do that for our 
container '72.dap.test'. When we enter the URL http://72.dap.test, by default port 80 will be used and our request 
will be forwarded to IP 127.0.0.72 (which we specified in hosts file). When that happens, we will forward that request 
to port 8072 on IP 127.0.0.1, because on that port we have our '72.dap.test' container waiting for requests 
(this is defined in docker-compose.yml).

On Windows OS, we can enter the following command to specify port forwarding:
```shell
netsh interface portproxy add v4tov4 listenport=80 listenaddress=127.0.0.72 connectport=8072 connectaddress=127.0.0.1
```
Once we do that, we can enter the URL 'http://72.dap.test' and our request will be forwarded to our '72.dap.test' 
container. Great!

To show all defined forwards:

```shell
netsh interface portproxy show v4tov4
```

If you know how to do this in different Linux distributions, let me know :). 

#### Running web application using HTTPS
All containers come with a self-signed certificate already included and configured with Apache.
To run a web app using HTTPS, you can simply use the "https://" scheme with the address, and then specify the correct 
port for the cpecific container, like this:

* https://56.dap.test:9056
* https://70.dap.test:9070
* https://71.dap.test:9071
* https://72.dap.test:9072
* https://73.dap.test:9073
* https://74.dap.test:9074

If you don't want to designate the port each time, you can, again, specify correct port forwarding for port 443, 
like this:

```shell
netsh interface portproxy add v4tov4 listenport=443 listenaddress=127.0.0.72 connectport=9072 connectaddress=127.0.0.1
```

Now we can access our web app over HTTPS by entering the address without port: 'https://72.dap.test'

### OpenLDAP

OpenLDAP containers are simply based on osixia/openldap which is available on Docker Hub. 
Some minor modifications for the default options were made using ENV variables:

- LDAP_TLS is set to "false"
- hostname is commented out
- domainname is commented out
- volume for /var/lib/ldap is set to ./ldap
- volume for /etc/ldap/slapd.d is set to ./slap.d
- new volume is added ./shared:/root/shared  

#### Running OpenLDAP Containers
Once you've cloned this repo, go to 'openldap' directory:

```shell
cd dockers/openldap
```

Here you'll find a 'docker-compose.yml' file. This means you can use 'docker-compose' command to easily run defined 
containers (you can edit that file to suit your needs if you wish):

```shell
docker-compose up -d
```