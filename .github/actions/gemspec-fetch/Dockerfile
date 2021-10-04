FROM ruby:3

RUN gem install parse_gemspec-cli

COPY entrypoint.sh /entrypoint.sh

ARG SPECFILE

ENTRYPOINT ["/entrypoint.sh"]