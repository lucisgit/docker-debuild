# Dockerfile for building Debian packages using current stable repo.
FROM debian:jessie
MAINTAINER Ruslan Kabalin <r.kabalin@lancaster.ac.uk>

RUN apt-get update && apt-get install -y --no-install-recommends \
  devscripts \
  equivs \
  rsync \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

VOLUME /package

COPY packagebuild /usr/local/bin/
RUN chmod 755 /usr/local/bin/packagebuild
CMD ["packagebuild"]
