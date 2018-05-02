FROM ubuntu:bionic

VOLUME /data

ENV PYLINT_VERSION=1.8.3

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

RUN apt-get update && apt-get install -y python python-pip python-dev build-essential
RUN pip install pylint==${PYLINT_VERSION}
RUN apt-get purge -y python-dev build-essential && apt-get -y autoremove && apt-get clean && rm -rf /tmp/*

WORKDIR /data

LABEL "maintainer"="cloudsquad@fxinnovation.com" \
      "org.label-schema.name"="pylint" \
      "org.label-schema.base-image.name"="docker.io/library/ubuntu" \
      "org.label-schema.base-image.version"="bionic" \
      "org.label-schema.description"="Pylint in a container" \
      "org.label-schema.url"="https://www.pylint.org/" \
      "org.label-schema.vcs-url"="https://bitbucket.org/fxadmin/public-common-docker-pylint" \
      "org.label-schema.vendor"="FXinnovation" \
      "org.label-schema.schema-version"="1.0.0-rc.1" \
      "org.label-schema.applications.pylint.version"=$PYLINT_VERSION \
      "org.label-schema.vcs-ref"=$VCS_REF \
      "org.label-schema.version"=$VERSION \
      "org.label-schema.build-date"=$BUILD_DATE \
      "org.label-schema.usage"="docker run --rm -v $(pwd):/data fxinnovation/pylint [PYLINT_COMPONENT] [COMMAND_OPTIONS]"
