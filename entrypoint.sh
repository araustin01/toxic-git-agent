#!/bin/sh

# Run built-in Docker startup commands
dockerd-entrypoint.sh &

echo "GITLAB_RUNNER_TOKEN is: ${GITLAB_RUNNER_TOKEN}"

# Run custom GitLab Runner commands
gitlab-runner register \
    --non-interactive \
    --url https://git.cs.vt.edu/ \
    --executor 'docker' \
    --docker-image ubuntu:latest \
    --description 'toxic-runner' \
    --token ${GITLAB_RUNNER_TOKEN}

gitlab-runner run
