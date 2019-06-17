FROM jenkinsci/jenkins:alpine

RUN usermod -u 1024 jenkins
RUN groupmod -g 100 jenkins
RUN find / -user 1000 -exec chown -h 1024 {} \;
RUN find / -group 1000 -exec chgrp -h 100 {} \;
RUN usermod -g 100 jenkins
