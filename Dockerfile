# Pull latest image.
FROM ubuntu:latest

# Install.
RUN \
  apt-get update && \
  apt-get install -y iproute2  && \
  apt-get install -y iputils-ping  && \
  apt-get install -y keepalived && \
  apt-get install -y conntrack && \
  apt-get install -y conntrackd && \
  apt-get install -y curl git vim iptables ulogd2

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

# Define default command.
CMD ["/bin/bash"]