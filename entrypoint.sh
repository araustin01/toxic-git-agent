#!/bin/sh

# Run built-in Docker startup commands
dockerd-entrypoint.sh &

# Run custom GitLab Runner commands
gitlab-runner register \
    --non-interactive \
    --url https://git.cs.vt.edu/ \
    --executor docker \
    --docker-privileged \
    --docker-volumes "/certs/client" \
    --docker-image ubuntu:latest \
    --description 'toxic-runner' \
    --token ${GITLAB_RUNNER_TOKEN}

gitlab-runner run
