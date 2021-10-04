FROM ruby:3

RUN gem install parse_gemspec-cli \
&& apt-get update \
&& apt-get install -y jq

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]