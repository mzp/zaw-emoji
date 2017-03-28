FROM ruby:2.4.0

RUN gem i bundler --no-document

RUN gem update --system

WORKDIR /zaw-emoji
