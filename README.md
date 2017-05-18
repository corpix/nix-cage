devcage
--------------

Development with Emacs in a container.

## Containers

There are containers for:

- go
- haskell
- python
- javascript
- everything (all containers in one)

All of them are built against a common container which contains Emacs.
The purpose of this containers is to divide a sets of tools between environments.

So every container will have Emacs + some set of tools to write code in specific language.

## Running a container

To run the container build with all tools:

``` shell
sudo rkt run                                                      \
    --interactive corpix.github.io/devcage/everything:1.0-a464316 \
    --volume=projects,kind=host,source=$HOME/Projects             \
    --volume=emacs,kind=host,source=$HOME/.emacs.d
```

## Projects structure

Directory at `~/Projects` contains all your projects.

The structure is the same as `GOPATH` for [go](https://golang.org/doc/code.html#GOPATH):

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

## Emacs configuration structure

When you running a container you need to pass a volume with Emacs configuration.

You can also pass your `~/.emacs` or move this file into `~/.emacs.d/init.el` which would be used in container entrypoint by default.
