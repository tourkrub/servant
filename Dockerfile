FROM ruby:2.6.2-alpine3.9

RUN mkdir /servant
WORKDIR /servant

RUN apk add --update ruby-dev build-base \
    libxml2-dev libxslt-dev pcre-dev libffi-dev \
    mariadb-dev postgresql-dev git

ADD /exe/servant /servant/exe/
ADD /lib/servant/version.rb /servant/lib/servant/
ADD /Gemfile Gemfile.lock servant.gemspec .git /servant/

RUN bundle install

ADD . /servant
