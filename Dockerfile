# syntax=docker/dockerfile:1
FROM maven:3.8.3-eclipse-temurin-17 AS build

WORKDIR /myproject

COPY pom.xml . 
COPY src src

RUN --mount=type=cache,id=mvncache,target=/root/.m2/repository,rw \
	mvn -B package

# Create a custom Java runtime from the dev env.
RUN MODULES=`jdeps  --ignore-missing-deps --list-deps target/DemoCI-1.0-SNAPSHOT-withdependencies.jar| grep -v -e jdk.compiler -e sun.security.krb5 | tr '\n' ','| tr -d "[:space:]"|head -c -1`  \
    && $JAVA_HOME/bin/jlink \
         --add-modules  $MODULES\
         --strip-debug \
         --no-man-pages \
         --no-header-files \
         --compress=2 \
         --output /javaruntime

FROM debian:bullseye-slim
# Copy the JRE from the dev build env
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH "${JAVA_HOME}/bin:${PATH}"
COPY --from=build /javaruntime $JAVA_HOME

# Copy the uber Jar from the dev build env
COPY --from=build /myproject/target/*-withdependencies.jar \
		  /myapp.jar

# Adds the wait script (see variable in docker-compose.yml)
ENV WAIT_VERSION 2.7.2
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/$WAIT_VERSION/wait /wait
RUN chmod +x /wait

ENTRYPOINT ["/bin/sh", "-c", "/wait && java -jar /myapp.jar"]
