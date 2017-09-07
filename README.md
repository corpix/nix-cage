devcage
--------------

Development with Emacs in a container.

## Containers

There are containers for:

- go
- haskell
- javascript
- everything (all containers in one)

All of them are built against a common container which contains Emacs.
The purpose of this containers is to divide a sets of tools between environments.

So every container will have Emacs + some set of tools to write code in specific language.

## Running a container

To run the container:

``` shell
sudo rkt run                                                      \
    --interactive corpix.github.io/devcage/everything:1.0-d7d0596 \
    --volume=projects,kind=host,source=$HOME/Projects             \
    --volume=emacs,kind=host,source=$HOME/.emacs.d                \
    --set-env=DEMOTE_UID=$(id -u) --set-env=DEMOTE_GID=$(id -g)   \
    --set-env=TERM=$TERM --net=host --dns=208.67.222.222 -- Projects/
```

Or you could use `devcage` script to run containers. To do this you should have a config file for a container.

Here is a config file for the `rkt run` above:

``` json
{
    "container": "corpix.github.io/devcage/everything:1.0-d7d0596",
    "mountpoints": {
        "~/Projects": "/home/user/Projects",
        "~/.emacs.d": "/home/user/.emacs.d"
    }
}
```

Save it to the file somethere:

``` shell
cat <<EOF > everything.json
{
    "container": "corpix.github.io/devcage/everything:1.0-d7d0596",
    "mountpoints": {
        "~/Projects": "/home/user/Projects",
        "~/.emacs.d": "/home/user/.emacs.d"
    }
}
EOF
```

And start the container:

> Rest of console arguments(after `--`) is passed to the Emacs in the container.

``` shell
devcage everything.json -- Projects/
```

## Projects structure

Directory at `~/Projects` contains all your projects.

The structure is the same as `GOPATH` for [go](https://golang.org/doc/code.html#GOPATH):

> You can move your projects using [this script](https://github.com/corpix/toolbox/blob/master/development/projects).

``` text
Projects/
    bin/
    pkg/
    src/
```

> `Projects/bin` will be added to `PATH`.

You place your projects by the URI of the project repository in SCM:

> No matter what language your project is written in,
> you always have a repository for your project which usually
> have a URI.

``` text
Projects/
    ...
    src/
        github.com/
            corpix/
                devcage/
                material-ui-boilerplate/
                flatstructs/
        bitbucket.org
            corpix/
                .../
```

## Entrypoint

Base container entrypoint script configures container user, manages environment, and starts the Emacs.

## UIDs

There are two environment variables each container receives:

- `DEMOTE_UID` defaults to 1000
- `DEMOTE_GID` defaults to 1000

They receive your user `uid` and `gid` to:

- run emacs with your `uid` and `gid`
- `chown` mountpoints inside container to your `uid` and `gid`
- and other permission related things to prepare environment for you

## Emacs configuration structure

When you running a container you need to pass a volume with Emacs configuration.

You can also pass your `~/.emacs` or move this file into `~/.emacs.d/init.el` which would be used in container entrypoint by default.


## Selinux

Make sure you volumes have correct type:

``` shell
sudo chcon -R -t container_file_t -r object_r -u system_u -l s0 ~/Projects
```

You will need to load a module for selinux because:

> This module targets Fedora linux.

- rkt selinux support in fedora is poor
- you will need allow container to work with your home directory(actually container work with parts of the home directory)

To load the module:

- make sure you have `container-selinux` package installed
- clone this repository
- navigate into `selinux` directory in your terminal
- run `make && sudo make install` to build and insert module

> You could uninstall module with `make uninstall`

## DNS

It is a good idea to specify a dns when running a container. You could use opendns servers:
``` text
--dns=208.67.222.222 --dns=208.67.220.220
```
