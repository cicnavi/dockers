
# cicnavi Docker Containers

These are LAMP (Debian linux, Apache, PHP - DAP) oriented containers which I use in my day-to-day development work.
Main purpose is to have development environment with different versions of PHP together with tools like
composer, phpunit, psalm, phpcs... In addition, typical services like databases are also available.

## Available containers

- DAP (Debian Apache PHP) containers follow the PHP version releases and have their names set corresponding the
  PHP version, for example:
    - 74.dap.test - PHP v7.4.*
    - 82.dap.test - PHP v8.2.*
    - ...
    - 08.dap.test - Latest PHP v8.*
- Database containers like MySQL, OpenLDAP, Redis...

## Run containers
Clone the repo, for example:

```shell
git clone https://github.com/cicnavi/dockers.git dockers
```

Go to 'dockers' directory:

```shell
cd dockers
```

Fetch certs (or refresh them when they expire):

```shell
./bin/refresh-certs.sh
```

Copy .env.example to .env and edit .env appropriately (it holds environment variables used to run containers). 

```shell
cp .env.example .env
```

You can use 'docker compose' command to easily run defined containers in file 'compose.yml'. 

```shell
docker compose up -d
```

If needed, create a copy of compose.yml and edit it to suit your needs. Then you can run your custom compose.yml:

```shell
docker compose -f custom-compose.yml up -d
```

### DAP (Debian Apache PHP) Containers

DAP containers are available with different PHP versions. Each folder in 'dap' folder corresponds to 
specific PHP version which is used in a container. So, with this approach we can easily run different containers 
to test our web application on different PHP version.

If you look at the 'compose.yml' file, you'll notice that besides DAP containers, it will also run database 
containers, like MySQL, Redis... 

#### Configuring Apache and PHP
Inside 'dap' folder, there is one folder for each PHP version. For each PHP version we can set custom Apache and PHP 
configuration. 

Apache configuration can be set by creating files ending in '.conf' in 'apache-config' folder.
In 'dap' folder you will find 'shared/src' folder, which can be used to share apache config across all containers.

Custom PHP configuration can be set in 'ini' files in 'php-config' folder.

#### Setting source files for your web application
In each PHP version folder you will find folders 'src' and 'html'.

Folder 'src' can contain source files which should be available to only one specific container.
You can use 'shared/src' folder to make it available to all containers 

The 'html' folder should contain files which will be served publicly by the Apache web server. 
By default, in 'html' folder you'll find 'index.php' file which will dump PHP information.

When you put application source files in 'src' folder, you can enter the 'bash' in the container, and create a symlink 
to the application source which will be served publicly (the same applies to 'shared' folder).

For example, let's enter the 'bash' in '81.dap.test' container:

```shell
docker exec -it 08.dap.test bash
```

By default, you'll be positioned in '/var/www/html' folder. Here you can create a symlink to a source file or folder 
you wish to be served by Apache:

```shell
ln -s ../src/some-php-app/public some-php-app
```

This will create a symbolic link 'some-php-app' which will point to 'public' folder of our PHP application. Of course, 
you should adjust symlinks to suit your needs.

#### Running web application
If you look at the 'compose.yml' file, you'll note that nginx reverse proxy is used in front of all DAP containers.
Each container has several virtual hosts appointed which can then be used to access specific container. By default,
everything is configured around a wildcard domain '*.localhost.markoivancic.form.hr', which has a real certificate
available, so you can use https scheme out of the box.

For example, container 08.dap.test has a virtual host '08-dap.localhost.markoivancic.from.hr' set. That means we can
access our web application on a URL:

https://08-dap.localhost.markoivancic.form.hr/some-php-app/.

If you only enter https://08-dap.localhost.markoivancic.form.hr, you'll get PHP info dump.

#### Specifying container host names and forwarding ports
You can edit your operating system hosts file and add host names for each container.
For example, you can add the following entries:

```
127.0.0.1 74.dap.test
...
127.0.0.1 08.dap.test
127.0.0.1 mysql.dap.test
```

This way you can enter URL for the container like this: 

http://08.dap.test 

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

# TODO
* Consider automatic cert download for localhost.markoivancic.from.hr on nginx proxy using script and specific build