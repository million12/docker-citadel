### Citadel Server in Docker  
[![Circle CI](https://circleci.com/gh/million12/docker-citadel/tree/master.svg?style=svg&circle-token=aac9a2809e0abdd64657d1d0f655997d017617f2)](https://circleci.com/gh/million12/docker-citadel/tree/master)  
[Docker image](https://hub.docker.com/r/million12/citadel) with [Citadel](http://www.citadel.org/doku.php) email server using CentOS-7 and supervisor. It's based on [million12/ssh](https://hub.docker.com/r/million12/ssh/) docker image with `ssh` deamon. This image comes with WebCit web interface installed and set to listen on port 80.

> Citadel is easy, versatile, and powerful, thanks to its exclusive "rooms" based architecture. No other platform seamlessly combines so many different features using this familiar and consistent metaphor.  

### Usage
Example `docker run` command:

    docker run \
      -d \
      -h mail.example.org \
      --name citadel \
      --dns 8.8.8.8 \
      -p 25:25 \
      -p 110:110 \
      -p 143:143 \
      -p 465:465 \
      -p 587:587 \
      -p 993:993 \
      -p 995:995 \
      -p 80:8080 \
      -p 10022:22 \
      --env="ROOT_PASS=myrootpassword" \
      --env="PASSWORD=mypassword" \
      --env="DOMAIN=example.org" \
      --env="ATOM_SUPPORT=true" \
      million12/citadel

### Environmental Variables
In this Image you can use environmental variables to define domain name, admin password, atom editor support and root ssh password.

`ROOT_PASS` = root user password (If not specified image will generate random password which can be retrieved usung `docker logs docker_name` command)  
`PASSWORD` = admin@example.org username password for logging to web interface  
`DOMAIN` = user specified domain name  
`ATOM_SUPPORT` = remote atom support for all of us who are using atom editor (disabled by default)

### Web Access
Go to `http://docker_container_address/`.  

Username `admin`  
Password `Password specified on docker run.`

### Docker troubleshooting


Use docker command to see if all required containers are up and running:

    $ docker ps -a

Check online logs of ssh container:

    $ docker logs citadel

Attach to running ssh container (to detach the tty without exiting the shell,
use the escape sequence Ctrl+p + Ctrl+q):

    $ docker attach citadel

Sometimes you might just want to review how things are deployed inside a running container, you can do this by executing a _bash shell_ through _docker's exec_ command:

    docker exec -i -t citadel /bin/bash

History of an image and size of layers:

    docker history --no-trunc=true million12/citadel | tr -s ' ' | tail -n+2 | awk -F " ago " '{print $2}'

---
## Author

Author: Przemyslaw Ozgo [linux@ozgo.info](mailto:linux@ozgo.info)

---

**Sponsored by** [Typostrap.io - the new prototyping tool](http://typostrap.io/) for building highly-interactive prototypes of your website or web app. Built on top of TYPO3 Neos CMS and Zurb Foundation framework.
