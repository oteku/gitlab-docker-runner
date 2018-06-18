# Runner for nodejs project
FROM ubuntu:latest

COPY go.sh go.sh

RUN chmod +x go.sh

# Install gitlab-runner and nodejs
RUN apt-get update -qy && \
    apt-get install -y curl && \
    curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | bash  && \
    apt-get install -y gitlab-runner

CMD [ "/go.sh" ]