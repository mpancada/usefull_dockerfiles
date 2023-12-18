# Used so I can quickly create a Rails App structure locally
# docker build -t rails_app_creator:7.1.2 -f rails_app_creator.Dockerfile .
# 
FROM ruby:3.2.2-alpine

RUN apk add make \
            gcc \
            libc-dev \
            git

RUN mkdir /opt/app

# by default documentation is not installed
RUN gem install 'bundler:2.4.22' \
                'rails:7.1.2'

WORKDIR /opt/app

CMD ["/bin/sh"]
