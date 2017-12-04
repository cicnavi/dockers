
# Debian, Apache, PHP

Each folder means specific PHP version.

To run a container:

In powershell, navigate to specific folder and then run:

```bash
docker run --name test -v $PWD/src:/var/www/src -v $PWD/html:/var/www/html -p 8080:80 cicnavi/test:1
```

For convinient access, in hosts file add, for example:

127.0.0.10 web71.dev

For Windows OS, we can also forward specific ports:
```bash
netsh interface portproxy add v4tov4 listenport=80 listenaddress=127.0.0.10 connectport=8080 connectaddress=127.0.0.1
netsh interface portproxy show v4tov4
```


