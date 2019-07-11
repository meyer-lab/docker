FROM jenkinsci/jenkins:2.184-alpine

USER root

RUN apk --no-cache add shadow restic

RUN usermod -u 1024 jenkins
RUN find / -user 1000 -exec chown -h 1024 {} \;

USER jenkins
