FROM jenkins:2.7.2
MAINTAINER Nick Weedon <nick@weedon.org.au>
USER root

RUN apt-get clean && apt-get update && apt-get install -y --no-install-recommends \
    nodejs \
    nodejs-legacy \
    npm \
    maven \
    git \
    ruby \
    software-properties-common \
    xml2

RUN npm install -g \
    bower \
    grunt \
    less

# Install Oracle Java 8
RUN \
    echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee /etc/apt/sources.list.d/webupd8team-java.list && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    apt-get update && \
    apt-get install -y oracle-java8-installer --no-install-recommends && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

COPY sencha/install-5.1.3.61.sh /tmp

RUN mkdir /opt/jenkins && chown jenkins.jenkins /opt/jenkins

USER jenkins 
RUN /usr/local/bin/install-plugins.sh \
    authorize-project:1.2.2 \
    ace-editor:1.1 \
    ansicolor:0.4.2 \
    ant:1.3 \
    artifactory:2.6.0 \
    batch-task:1.19 \
    ci-skip:0.0.2 \
    config-file-provider \
    copyartifact:1.38.1 \
    deploy:1.10 \
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
    ruby-runtime:0.13

ENV PATH="${PATH}:/opt/jenkins/Sencha/Cmd/5.1.3.61"

RUN cd /tmp && \
    ./install-5.1.3.61.sh && \
    sencha package repo init -name "Nick Weedon" -email "nick@weedon.org.au"


