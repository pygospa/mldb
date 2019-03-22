FROM ruby:2.6-alpine

# build-base		for gem compilation
# postgresql-dev	for pg gem
# nodejs+tzdata		for rails
RUN apk add --no-cache build-base \
		       nodejs \
		       postgresql-dev \
		       tzdata

WORKDIR /srv/mldb

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .
