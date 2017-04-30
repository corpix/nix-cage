devcage
--------------

Development with Emacs in a container.

## Why?

I am concerned about the tools I have in my Linux system. I have tons of them.
And every time I run `go get ...` or `npm install ...` or something other(pip, stack, cabal, cargo, whatever)
this tools could do so much things to my system and my files which I don't want to happen.
Also this tools being run inherit a permissions of the user they was run by.

Sometimes I think that my system is just a big junkyard lacking control and transparency.

In Linux we have a nice thing called containers. They acts like a sandboxes for the applications.
And you could apply various restrictions to them. So... why not use the containers for your development environment?

Cons and pros:

- Containers are stateless(reboot them to loose your state)


## Containers

There are containers for:

- go
- haskell
- python
- javascript

All of them are built against a common container which contains Emacs.
The purpose of this containers is to divide a sets of tools between environments.

So every container will have Emacs + some set of tools to write code in specific language.

> What if I want to develop in go+javascript in the same Emacs instance?
> With this approach you will need to build a separate container which will
> contain all tools to compile go and run javascript. But probably I will make a
> container with all tools in one in the future, will see.

## Workflow

### Projects

This directory contains all your projects.

The structure is the same as `GOPATH` for [go](https://golang.org/doc/code.html#GOPATH):

``` text
Projects/
    bin/
    pkg/
    src/
```

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
                developer-cage/
                material-ui-boilerplate/
                flatstructs/
        bitbucket.org
            corpix/
                .../
```

### Emacs socket

In each container Emacs is started with additional lisp file which will do:

> Emacs starts with `-l <list-file.el>`.

``` emacs-lisp
(setq server-socket-dir "/var/run/emacs")
```
