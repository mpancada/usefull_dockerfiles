##### This IS ONLY FOR -slim containers like ruby:3.2.2-slim #####

# Used for WSL so I can quickly create a rails project and work in it

# TO BUILD a new image
# sudo docker build -t rails_app:7.1.2 -f rails_app_creator.Dockerfile .

# USE RAILS AS USUAL
# CREATE a project
# # sudo docker run --rm -v .:/home/mpancada/rails_app rails_app:7.1.2 rails new test_app
# START SERVER
# # sudo docker run --rm -v .:/home/mpancada/rails_app -p 3000:3000 rails_app:7.1.2 bin/rails server -b "0.0.0.0"
# USE CONSOLE
# # sudo docker run --rm -v .:/home/mpancada/rails_app -it rails_app:7.1.2 rails c

### ADVICE ####

# Create a dev_server.sh
# # sudo docker run --rm -v .:/home/mpancada/rails_app -p 3000:3000 rails_app:7.1.2 bin/rails server -b "0.0.0.0"
# Create a dev_c.sh
# # sudo docker run --rm -v .:/home/mpancada/rails_app -it rails_app:7.1.2 rails c
# Create a dev_rails
# # sudo docker run --rm -v .:/home/mpancada/rails_app rails_app:7.1.2 bin/rails

### This way you dont need to write so much to work!! ###

FROM ruby:3.2.2-slim

#Its important to create a user with the same name as your WSL so you dont have permissions problems related to files
ARG USERNAME='mpancada'

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libvips pkg-config

RUN useradd ${USERNAME} --create-home --shell /bin/bash

USER ${USERNAME}:${USERNAME}

RUN mkdir /home/${USERNAME}/rails_app

WORKDIR /home/${USERNAME}/rails_app

# save the bundled gems locally on the project directory
# Dont forget to .gitignore this folder
ENV BUNDLE_PATH="./_bundle"

# by default documentation is not installed
RUN gem install 'bundler:2.4.22' \
                'rails:7.1.2'


CMD ["/bin/bash"]
