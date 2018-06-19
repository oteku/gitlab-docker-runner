#!/bin/sh

# Get the id of the runner (if exists)
id=$(curl --header \
  "PRIVATE-TOKEN: $PERSONAL_ACCESS_TOKEN" \
  "$GITLAB_INSTANCE/api/v4/runners" | python3 -c \
'
import sys, json;
json_data=json.load(sys.stdin)
for item in json_data:
  if item["description"] == "'$RUNNER_NAME'":
    print(item["id"])
')

echo "👋 id of $RUNNER_NAME runner is: $id"

echo "⚠️ trying to deactivate runner..."

curl --request DELETE --header \
  "PRIVATE-TOKEN: $PERSONAL_ACCESS_TOKEN" \
  "$GITLAB_INSTANCE/api/v4/runners/$id"


# Register, then run the new runner
echo "👋 launching new gitlab-runner"
  
# gitlab-runner register --non-interactive \
#   --url "$GITLAB_INSTANCE/" \
#   --name $RUNNER_NAME \
#   --tag-list "docker,node,clevercloud" \
#   --docker-image node:8 \
#   --registration-token $TOKEN_GROUP \
#   --executor docker

docker run --rm -t -i -v /path/to/config:/etc/gitlab-runner --name gitlab-runner gitlab/gitlab-runner register \
  --non-interactive \
  --name $RUNNER_NAME \
  --executor "docker" \
  --docker-image node:8 \
  --url $GITLAB_INSTANCE \
  --registration-token $TOKEN_GROUP \
  --tag-list "docker,clevercloud" 

docker run -d --name gitlab-runner --restart always \
  -v /srv/gitlab-runner/config:/etc/gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  gitlab/gitlab-runner:latest &

# Need to start a server on 8080 to keep CleverCloud alive
echo "🌍 executing the http server"
http-server -p 8080