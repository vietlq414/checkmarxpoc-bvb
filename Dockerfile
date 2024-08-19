FROM docker.io/openjdk:8-jre-alpine as BUILD

RUN apk update && apk add
RUN apk add ca-certificates libstdc++ glib curl unzip



RUN adduser --system --home /home/easybuggy easybuggy
RUN cd /home/easybuggy/;
RUN chgrp -R 0 /home/easybuggy
RUN chmod -R g=u /home/easybuggy
USER easybuggy
WORKDIR /home/easybuggy
COPY target/easybuggy.jar /home/easybuggy/easybuggy.jar
EXPOSE 8080

CMD ["java", "-jar", "-Dspring.profiles.active=test", "/home/easybuggy/easybuggy.jar"]
