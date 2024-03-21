FROM ubuntu:latest

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl \
                       apt-transport-https \
                       ca-certificates \
                       gnupg \
                       lsb-release \
                       software-properties-common

# Add Docker's official GPG key
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the stable repository
RUN echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
RUN apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io

# Install GitLab Runner
RUN curl -L --output /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64
RUN chmod +x /usr/local/bin/gitlab-runner

# Create a GitLab Runner user
RUN useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash

# Install and configure GitLab Runner
RUN gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
RUN gitlab-runner start

# Set the user to run commands
USER gitlab-runner
WORKDIR /home/gitlab-runner

# Start the GitLab Runner service
CMD ["gitlab-runner", "run", "--working-directory=/home/gitlab-runner"]
