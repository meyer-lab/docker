FROM jenkinsci/jenkins:alpine

USER root

RUN apk --no-cache add shadow

RUN usermod -u 1024 jenkins
RUN find / -user 1000 -exec chown -h 1024 {} \;

USER jenkins
