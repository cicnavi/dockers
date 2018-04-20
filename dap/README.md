# DAP (Debian Apache PHP) Containers

Each folder specifies a Docker container with specific PHP version.

To run a container, navigate to specific folder designatig PHP version and then run the following command (adjust container name and DAP version as needed):

```shell
docker run --name 71.dap.test -v $PWD/src:/var/www/src -v $PWD/html:/var/www/html -p 8071:80 cicnavi/dap:7.1
```

In 'dap' folder, there is a 'docker-compose.yml' file, which means you can run all defined containers with single command:

```shell
docker-compose up -d
```

Once containers are up, in your browser use localhost URL with appropriate port, for example: http://localhos:8071