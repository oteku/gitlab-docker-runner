# Runner for nodejs project
FROM ubuntu:latest

COPY go.sh go.sh
COPY index.html index.html

RUN chmod +x go.sh

# Install gitlab-runner and nodejs
RUN apt-get update -qy && \
    apt-get install -y curl && \
    curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | bash  && \
    apt-get install -y gitlab-runner && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash  && \
    apt-get -y install nodejs && \
    npm install http-server -g

CMD [ "/go.sh" ]