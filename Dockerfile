FROM ruby:2.7.1-alpine3.12

LABEL "com.carlosassis.dns_records"="DNS Records"
LABEL "description"="DNS Records application"

ENV RAILS_ENV=production

RUN mkdir -p /app

WORKDIR /app

RUN apk add --update --no-cache \
    binutils-gold \
    curl \
    g++ \
    gcc \
    gnupg \
    libgcc \
    linux-headers \
    make \
    linux-headers \
    postgresql \
    postgresql-contrib \
    postgresql-libs \
    postgresql-dev
RUN gem update --system
RUN gem install rails bundler

EXPOSE 3000

COPY . /app
RUN bundle install

ENTRYPOINT [ "bin/start" ]
CMD [ "server", "-b", "0.0.0.0" ]
