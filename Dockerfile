# --- STAGE 1: Construcción (Build) ---
FROM gradle:8.5-jdk21 AS build
WORKDIR /app
COPY build.gradle settings.gradle ./
COPY src ./src
RUN gradle bootJar -x test --no-daemon

# --- STAGE 2: Ejecución (Run) ---
# CAMBIO REALIZADO AQUÍ: Usamos eclipse-temurin en lugar de openjdk
FROM eclipse-temurin:21-jdk
WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]