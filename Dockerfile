FROM ruby:2.0
MAINTAINER leo.lou@gov.bc.ca
ENV NOKOGIRI_USE_SYSTEM_LIBRARIES true

RUN \
  DEBIAN_FRONTEND=noninteractive yum update \
  && DEBIAN_FRONTEND=noninteractive yum install -y \
    curl pkg-config build-essential nodejs git libxml2-dev libxslt-dev \
  && git config --global url.https://github.com/.insteadOf git://github.com/ \
  && gem install nokogiri --no-ri --no-rdoc bundler --use-system-libraries -N \

ADD . /usr/src/app
 
RUN bundle config build.nokogiri --use-system-libraries && bundle install

RUN useradd -ms /bin/bash slate \
  && chown -R slate:0 /usr/src/app \
  && chmod -R 770 /usr/src/app

USER slate
WORKDIR /usr/src/app
EXPOSE 4567
CMD bundle exec middleman server
