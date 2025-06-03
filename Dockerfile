# Use an official Maven image with JDK 21 to build the project
FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /app

# Copy Maven configuration and source files
COPY mvnw .
COPY mvnw.cmd .
COPY pom.xml .
COPY src ./src

# Build the project and package the WAR, skipping tests for faster build
RUN mvn clean package -DskipTests

# Use an official Tomcat image with JDK 21 for running the WAR
FROM tomcat:10.1-jdk21-openjdk
WORKDIR /usr/local/tomcat/webapps

# Copy the built WAR from the build stage to Tomcat's webapps directory
COPY --from=build /app/target/bookstore.war ./ROOT.war

# Expose port 8080 (Tomcat's default port, required for Render)
EXPOSE 8080

# Explicitly set the command to start Tomcat
CMD ["catalina.sh", "run"]