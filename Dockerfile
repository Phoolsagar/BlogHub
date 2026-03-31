# Stage 1: Build
FROM eclipse-temurin:21-jdk AS builder

WORKDIR /app

COPY gradlew .
COPY gradle gradle
COPY build.gradle settings.gradle .
COPY src src

RUN chmod +x gradlew
RUN ./gradlew bootJar -x test

# Stage 2: Run
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copy ANY jar dynamically
COPY --from=builder /app/build/libs/*.jar app.jar

# Render uses dynamic PORT
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
