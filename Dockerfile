FROM openjdk:8-jdk-alpine

VOLUME /tmp

COPY . /usr/src/myapp 
WORKDIR /usr/src/myapp 
RUN apk add curl
ENV MAVEN_VERSION 3.3.9

ENV PORT 5000
EXPOSE 5000

RUN mkdir -p /usr/share/maven \
  && curl -fsSL http://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
    | tar -xzC /usr/share/maven --strip-components=1 \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
RUN mvn --batch-mode -f /usr/src/myapp/pom.xml clean package

ENTRYPOINT ["java","-Dserver.port=5000", "-Djava.security.egd=file:/dev/./urandom","-jar","target/gs-spring-boot-0.1.0.jar"]