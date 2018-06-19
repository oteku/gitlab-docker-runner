# Runner for nodejs project
FROM ubuntu:latest

COPY go.sh go.sh
COPY index.html index.html

RUN chmod +x go.sh

# Install gitlab-runner and nodejs
RUN apt-get install -y curl && \
    curl -sSL https://get.docker.com/ | sh && \
    apt-get -y install nodejs && \
    npm install http-server -g

CMD [ "/go.sh" ]