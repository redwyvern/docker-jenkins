FROM jenkins:2.7.2
MAINTAINER Nick Weedon <nick@weedon.org.au>

# The timezone for the image (set to Etc/UTC for UTC)
ARG IMAGE_TZ=America/New_York

USER root
RUN echo ${IMAGE_TZ} > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

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

