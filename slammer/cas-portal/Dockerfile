FROM ruby:2.1.5
RUN apt-get update -qq && apt-get install -y build-essential nodejs npm nodejs-legacy mysql-client nano
RUN npm install -g phantomjs

RUN mkdir /portal

WORKDIR /portal
COPY vendor vendor
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle install

ADD . /portal
WORKDIR /portal
RUN bundle exec rake assets:precompile --trace
CMD ["rails","server","-b","0.0.0.0"]
