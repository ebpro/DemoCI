# syntax=docker/dockerfile:1
FROM maven:3.8.3-eclipse-temurin-17 AS build

WORKDIR /myproject

COPY pom.xml . 
COPY src src

RUN --mount=type=cache,id=mvncache,target=/root/.m2/repository,rw \ 
	mvn -B package

FROM eclipse-temurin:11.0.13_8-jre-alpine
COPY --from=build /myproject/target/*-with-dependencies.jar \
		  /myapp.jar

ENTRYPOINT ["java", "-jar"]
CMD ["/myapp.jar"]
