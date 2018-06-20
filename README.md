# docker-debuild

This is a docker image that allows you to build the Debian package in a
clean Debian container using [debuild](https://manpages.debian.org/jessie/devscripts/debuild.1.en.html) with only build dependant packages installed. All
you need is to run a container having mounted your project directory
(containing all the files required for Debian packaging) to `/package` path
inside the container.  Upon completion all generated files necessary for
uploading a Debian package will be placed in your project directory.

## How it works

Internally entrypoint script inside container does the following: 

* Create a copy of the content of `/package` volume, installing build dependancies according to your `debian/control`;
* Run `debuild` using default configuration defined in [~/.devscripts](devscripts);
* Copy generated files back to `/package` volume, so they are accessbile on host for repo uploading or direct use with dpkg.

Any options passed to entrypoint script via `docker run` will be seamlessly
passed to debuild, i.e. `docker run --rm -v $(pwd):/package
lucisgit/docker-debuild -b` will run `debuild -b` on your code. Refer to
[debuild
manpage](https://manpages.debian.org/jessie/devscripts/debuild.1.en.html)
for the full list of options.

You can pass environment varables as well if required, e.g.
```bash
docker run --rm -e DEB_BUILD_OPTIONS=noddebs -v $(pwd):/package lucisgit/docker-debuild
```

## Choosing Debian release

Use docker image tag for particular version of Debian in your build
container, i.e. lucisgit/docker-debuild:jessie will provide you with Debian 8.x (Jessie). Using no tag, *latest* or *stable* corresponds to current stable release of Debian. 
Repo branches correspond to the docker image tags, so you can easily see
which releases are supported.

## Locale

You may switch locale by providing the one you need in LOCALE env variable, e.g.

```bash
$ docker run --rm -v $(pwd):/package -e LOCALE=en_GB.UTF-8 lucisgit/docker-debuild -b
```

## Usage example

Let's build existing package for demo purposes. We will use
[fdupes](https://packages.debian.org/jessie/fdupes) and run binary-only
build (passing `-b` parameter).

```bash
$ apt-get source fdupes
$ cd fdupes-1.51
$ docker run --rm -v $(pwd):/package lucisgit/docker-debuild -b
Preparing package fdupes-1.51-1 for building.
Installing package dependencies...
...
Package fdupes-1.51-1 has been built, generated files have been placed in
your local package directory
$ ls fdupes_1.51-1*
fdupes_1.51-1_amd64.build  fdupes_1.51-1_amd64.changes
fdupes_1.51-1_amd64.deb
```
