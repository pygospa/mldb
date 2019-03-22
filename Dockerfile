FROM ruby:2.6-alpine

# build-base		for gem compilation
# postgresql-dev	for pg gem
# nodejs+tzdata		for rails
RUN apk add --no-cache --virutal build-base \
				 nodejs \
				 postgresql-dev \
				 tzdata

RUN mkdir /srv/mldb

COPY Gemfile Gemfile.lock /srv/mldb/

WORKDIR /srv/mldb

RUN bundle install

COPY . /srv/mldb
