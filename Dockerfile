#
## JRuby.js Dockerfile
##
## https://github.com/carlos4ndre/jruby-dockerfile
#
FROM phusion/baseimage:0.9.15
MAINTAINER Carlos André @carlos4ndre

# Set JRuby version.
ENV JRUBY_VERSION 1.7.15

# Set correct environment variables.
ENV HOME /root
ENV PATH /opt/jruby-$JRUBY_VERSION/bin:$PATH

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

#
# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Install Java 8.
RUN \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    apt-get install -y oracle-java8-installer && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/oracle-jdk8-installer

# Install JRuby.
RUN \
    curl http://jruby.org.s3.amazonaws.com/downloads/$JRUBY_VERSION/jruby-bin-$JRUBY_VERSION.tar.gz | tar xz -C /opt

# Define working directory.
WORKDIR /root

# Define default command.
CMD ["bash"]
