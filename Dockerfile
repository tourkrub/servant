FROM ruby:2.6.2-alpine3.9

RUN mkdir /servant
WORKDIR /servant

ADD /lib/servant/version.rb /servant/lib/servant/
ADD /Gemfile Gemfile.lock servant.gemspec /servant/

RUN bundle install

ADD . /servant
