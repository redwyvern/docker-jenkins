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
    icon-shim:2.0.3 \
    greenballs:1.15.1 \
    envinject:2.3.0 \
    maven-plugin:3.8 \
    docker-workflow:1.25 \
    batch-task:1.19 \
    ldap:1.26 \
    pipeline-build-step:2.13 \
    jackson2-api:2.12.0 \
    plain-credentials:1.7 \
    branch-api:2.6.2 \
    subversion:2.13.2 \
    bootstrap4-api:4.5.3-1 \
    okhttp-api:3.14.9 \
    jsch:0.1.55.2 \
    workflow-support:3.7 \
    next-build-number:1.6 \
    doxygen:0.18 \
    disk-usage:0.28 \
    warnings:4.63 \
    lockable-resources:2.10 \
    envinject-api:1.7 \
    ivy:2.1 \
    pipeline-model-api:1.7.2 \
    matrix-auth:2.6.4 \
    ws-cleanup:0.38 \
    ant:1.11 \
    plugin-util-api:1.6.1 \
    copyartifact:1.45.3 \
    sidebar-link:1.11.0 \
    scm-api:2.6.4 \
    ci-skip:0.0.2 \
    git:4.5.1 \
    workflow-aggregator:2.6 \
    resource-disposer:0.14 \
    pipeline-stage-tags-metadata:1.7.2 \
    github-branch-source:2.9.3 \
    git-client:3.6.0 \
    workflow-step-api:2.23 \
    pipeline-input-step:2.12 \
    pipeline-stage-view:2.19 \
    durable-task:1.35 \
    workflow-cps-global-lib:2.17 \
    pipeline-model-definition:1.7.2 \
    build-timeout:1.20 \
    matrix-project:1.18 \
    htmlpublisher:1.25 \
    workflow-durable-task-step:2.37 \
    jquery-detached:1.2.1 \
    deploy:1.16 \
    authentication-tokens:1.4 \
    ace-editor:1.1 \
    jdk-tool:1.4 \
    Exclusion:0.12 \
    display-url-api:2.3.4 \
    cobertura:1.16 \
    workflow-cps:2.87 \
    pipeline-stage-step:2.5 \
    xunit:3.0.0 \
    git-server:1.9 \
    dtkit-api:3.0.0 \
    ansicolor:0.7.3 \
    pipeline-milestone-step:1.3.1 \
    structs:1.20 \
    authorize-project:1.3.0 \
    snakeyaml-api:1.27.0 \
    pipeline-model-declarative-agent:1.1.1 \
    checks-api:1.2.0 \
    popper-api:1.16.0-7 \
    workflow-multibranch:2.22 \
    junit:1.48 \
    mailer:1.32.1 \
    run-condition:1.5 \
    github-pullrequest:0.2.8 \
    rebuild:1.31 \
    antisamy-markup-formatter:2.1 \
    pipeline-github-lib:1.0 \
    mapdb-api:1.0.9.0 \
    ssh-credentials:1.18.1 \
    cppcheck:1.25 \
    config-file-provider:3.7.0 \
    token-macro:2.13 \
    windows-slaves:1.7 \
    project-inheritance:19.08.02 \
    gradle:1.36 \
    cloudbees-folder:6.15 \
    jquery3-api:3.5.1-2 \
    javadoc:1.6 \
    workflow-scm-step:2.11 \
    github-api:1.117 \
    external-monitor-job:1.7 \
    momentjs:1.1.1 \
    github-organization-folder:1.6 \
    pipeline-model-extensions:1.7.2 \
    code-coverage-api:1.2.0 \
    workflow-job:2.40 \
    handlebars:1.1.1 \
    jaxb:2.3.0.1 \
    jacoco:3.1.0 \
    email-ext:2.80 \
    postbuildscript:2.11.0 \
    workflow-api:2.40 \
    credentials-binding:1.24 \
    font-awesome-api:5.15.1-1 \
    ruby-runtime:0.13 \
    artifactory:3.10.1 \
    pipeline-graph-analysis:1.10 \
    trilead-api:1.0.13 \
    pam-auth:1.6 \
    bouncycastle-api:2.18 \
    gitlab-logo:1.0.5 \
    command-launcher:1.5 \
    analysis-core:1.92 \
    docker-commons:1.17 \
    pipeline-rest-api:2.19 \
    timestamper:1.11.8 \
    nodejs:1.3.10 \
    script-security:1.75 \
    echarts-api:4.9.0-2 \
    build-token-root:1.7 \
    workflow-basic-steps:2.23 \
    github:1.32.0 \
    ssh-slaves:1.31.4 \
    apache-httpcomponents-client-4-api:4.5.10-2.0 \
    credentials:2.3.14
