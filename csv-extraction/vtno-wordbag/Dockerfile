FROM ruby:3.0-alpine

COPY Gemfile .

RUN apk update \
    && apk add --no-cache build-base \
    && bundle install

ENTRYPOINT [ "ruby" ]

CMD ["main.rb"]
