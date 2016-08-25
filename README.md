![](https://img.shields.io/docker/stars/redwyvern/jenkins.svg)
![](https://img.shields.io/docker/pulls/redwyvern/jenkins.svg)
![](https://img.shields.io/docker/automated/redwyvern/jenkins.svg)
[![](https://images.microbadger.com/badges/image/redwyvern/jenkins.svg)](https://microbadger.com/images/redwyvern/jenkins "Get your own image badge on microbadger.com")

Redwyvern Jenkins
=================

This is the Jenkins Docker image for Redwyvern software.

The following steps must still be performed manually:

1. Set up SMTP server e-mail configuration
2. Set up admin e-mail (Jenkins Location)
3. Set up NodeJs settings => Name: NativeNodeJS, Install Dir: /usr/bin
4. Set up Maven settings => Name: Native Maven, MAVEN_HOME: /usr/share/maven
5. Add 'jenkins-ro' key
6. Add 'jenkins' key in jenkins user .ssh dir
7. Add 'git-hub' credentials
8. Set up 'artifactory' configuration and 'jenkins' artifactory user password => Server ID: redwyvern, URL: http://artifactory.redwyvern.com/artifactory
9. Set git author and name (git config --global user.email "jenkins@weedon.org.au" and git config --global user.name "Jenkins")
10. Set git to use new push behavior (git config --global push.default matching)
11. Add jenkins id_rsa and id_rsa.pub to .ssh (needed for command line commits)

TODO:
1. Split out jobs, builds and workspaces
2. Move git author and push behavior to image

