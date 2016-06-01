FROM ruby:latest
MAINTAINER leo.lou@gov.bc.ca
ENV NOKOGIRI_USE_SYSTEM_LIBRARIES true
ENV LC_CTYPE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANG C.UTF-8

RUN \
  DEBIAN_FRONTEND=noninteractive apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl pkg-config build-essential nodejs git libxml2-dev libxslt-dev \
  && git config --global url.https://github.com/.insteadOf git://github.com/ \
  && gem install nokogiri --no-ri --no-rdoc bundler --use-system-libraries -N \
  && DEBIAN_FRONTEND=noninteractive apt-get purge -y \
  && DEBIAN_FRONTEND=noninteractive apt-get autoremove -y \
  && DEBIAN_FRONTEND=noninteractive apt-get clean \  
  && rm -Rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD . /usr/src/app
 
RUN bundle config build.nokogiri --use-system-libraries && bundle install

RUN useradd -ms /bin/bash slate \
  && chown -R slate:0 /usr/src/app \
  && chmod -R 770 /usr/src/app

USER slate
WORKDIR /usr/src/app
EXPOSE 4567
CMD bundle exec middleman server
