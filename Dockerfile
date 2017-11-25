FROM jenkins/jenkins:lts
MAINTAINER Nick Weedon <nick@weedon.org.au>

# The timezone for the image (set to Etc/UTC for UTC)
ARG IMAGE_TZ=America/New_York

USER root

# Add some necessary utility packages to bootstrap the install process
RUN apt-get clean && apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    locales \
    tzdata \
    apt-transport-https \
    ca-certificates \
    software-properties-common && \
    apt-get -q autoremove && \
    apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin

# Add locales after locale-gen as needed
# Upgrade packages on image
# Preparations for sshd
RUN locale-gen en_US.UTF-8 &&\
    apt-get -q update &&\
    DEBIAN_FRONTEND="noninteractive" apt-get -q upgrade -y -o Dpkg::Options::="--force-confnew" --no-install-recommends &&\
    DEBIAN_FRONTEND="noninteractive" apt-get -q install -y -o Dpkg::Options::="--force-confnew"  --no-install-recommends openssh-server &&\
    apt-get -q autoremove &&\
    apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin &&\
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd &&\
    mkdir -p /var/run/sshd

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Set the timezone
# Normally this would be done via: echo ${IMAGE_TZ} >/etc/timezone && dpkg-reconfigure -f noninteractive tzdata 
# A bug in the current version of Ubuntu prevents this from working: https://bugs.launchpad.net/ubuntu/+source/tzdata/+bug/1554806
# Change this to the normal method once this is fixed.
RUN ln -fs /usr/share/zoneinfo/${IMAGE_TZ} /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

# Create the builds volume
RUN mkdir -p /opt/jenkins/builds && chown -R jenkins.jenkins /opt/jenkins 
VOLUME /opt/jenkins/builds

USER jenkins 
RUN /usr/local/bin/install-plugins.sh \
    analysis-core:1.79 \
    authorize-project:1.2.2 \
    ace-editor:1.1 \
    ansicolor:0.4.2 \
    ant:1.3 \
    artifactory:2.6.0 \
    batch-task:1.19 \
    ci-skip:0.0.2 \
    cobertura:1.9.8 \
    config-file-provider \
    copyartifact:1.38.1 \
    cppcheck:1.21 \
    deploy:1.10 \
    disk-usage:0.28 \
    doxygen:0.18 \
    envinject:1.92.1 \
    Exclusion:0.12 \
    greenballs:1.15 \
    htmlpublisher:1.11 \
    ivy:1.26 \
    jacoco:2.0.1 \
    javadoc:1.4 \
    maven-plugin:2.13 \
    next-build-number:1.4 \
    nodejs:0.2.1 \
    postbuildscript:0.17 \
    ruby-runtime:0.13 \
    sidebar-link:1.7 \
    warnings:4.56 \
    xunit:1.102

