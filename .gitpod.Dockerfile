# You can find the new timestamped tags here: https://hub.docker.com/r/gitpod/workspace-full/tags
FROM gitpod/workspace-full:latest

# Install custom tools, runtime, etc.
RUN wget http://apt.puppetlabs.com/puppet-release-$(lsb_release -c -s).deb && \
  sudo dpkg -i puppet-release-$(lsb_release -c -s).deb && \
  rm puppet-release-$(lsb_release -c -s).deb && \
  sudo apt-get update && \
  sudo apt-get -y install puppet-agent pdk

ADD --chown=gitpod:gitpod .gitpod-puppet-analytics.yml /home/gitpod/.config/puppet/analytics.yml
