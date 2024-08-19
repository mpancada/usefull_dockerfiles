##### This IS ONLY FOR -slim containers like ruby:3.2.2-slim #####

# Used for WSL so I can quickly create a rails project and work in it

# Install docker on WSL
    # https://docs.docker.com/engine/install/ubuntu/
# Change the firewall to legacy iptables
    # # update-alternatives --config iptables
# Only then, you will be able to sudo docker run hello-world

##############################
######### JUST DOCKER ########
##############################
    # To build a new image
        # sudo docker build --build-arg USERNAME=$(whoami) --build-arg RAILS_V=7.2 -t mailmarketing -f rails_app_creator.Dockerfile .

    # USE RAILS AS USUAL
        # CREATE a project
            # sudo docker run --rm -v .:/rails_app rails_app:7.1.2 rails new test_app
        # START SERVER
            # sudo docker run --rm -v .:/rails_app -p 3000:3000 rails_app:7.1.2 bin/rails server -b "0.0.0.0"
        # USE CONSOLE
            # sudo docker run --rm -v .:/rails_app -it rails_app:7.1.2 rails c

        ### ADVICE ####

            # Create a dev_server.sh
                # sudo docker run --rm -v .:/rails_app -p 3000:3000 rails_app:7.1.2 bin/rails server -b "0.0.0.0"
            # Create a dev_c.sh
                # sudo docker run --rm -v .:/rails_app -it rails_app:7.1.2 rails c
            # Create a dev_rails
                # sudo docker run --rm -v .:/rails_app rails_app:7.1.2 bin/rails
################################
#### OR USE DOCKER COMPOSE #####
################################
        # BUILD the image
            # sudo docker build --build-arg USERNAME=$(whoami) --build-arg RAILS_V=7.2 -t mailmarketing -f rails_app_creator.Dockerfile .
        # Start rails application
            # sudo docker compose -f dev.docker-compose.yml up
        # Enter into container to exec rails commands
            # sudo docker compose -f dev.docker-compose.yml exec rails_app bash
        ##OR##
            # sudo docker compose -f dev.docker-compose.yml exec rails_app rails db:migrate

        # Create alias to write less...
            # alias _dc='sudo docker compose -f dev.docker-compose.yml'
            # alias _dcrails='sudo docker compose -f dev.docker-compose.yml exec rails_app rails'
        #Filename: dev.docker-compose.yml

        #volumes:
        #    main_db_data:
        #  services:
        #    rails_app:
        #      image: mailmarketing
        #      command: bin/rails server -b "0.0.0.0"
        #      volumes:
        #        - .:/rails_app
        #      ports:
        #        - 3000:3000
        #      environment:
        #        - RAILS_ENV=development
        #    main_db:
        #      image: postgres
        #      volumes:
        #       - main_db_data:/var/lib/postgresql/data
        #      ports:
        #       - 15432:5432
        #      environment:
        #        - POSTGRES_USER=myuser
        #        - POSTGRES_PASSWORD=mypassword
        #        - POSTGRES_DB=dev_mailmarketing
            #restart: always
############################################################

ARG RUBY_V=3.3.4
FROM ruby:${RUBY_V}-slim

#Its important to create a user with the same name as your WSL so you dont have permissions problems related to files
ARG USERNAME
ARG RAILS_V

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libvips pkg-config

# install gem pg dependencies
# RUN apt-get install libpq5 libpq-dev

RUN useradd ${USERNAME} --create-home --shell /bin/bash

RUN mkdir /rails_app
RUN chown -R ${USERNAME}:${USERNAME} /rails_app

USER ${USERNAME}:${USERNAME}

WORKDIR /rails_app

# save the bundled gems locally on the project directory
# Dont forget to .gitignore this folder
ENV BUNDLE_PATH="./_bundle"

# by default documentation is not installed
RUN gem install 'bundler' \
                "rails:${RAILS_V}"


CMD ["/bin/bash"]
