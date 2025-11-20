# imagen de Gradle con JDK 21 para compilar
FROM gradle:8.5-jdk21 AS build

# directorio de trabajo
WORKDIR /app

# copiamos los archivos de configuración de Gradle
COPY build.gradle settings.gradle ./

# cpiamos el código fuente
COPY src ./src

# Ejecutamos el comando para construir el archivo .jar (saltando los tests para ahorrar tiempo)
RUN gradle bootJar -x test --no-daemon


# imagen ligera de OpenJDK 21 para ejecutar
FROM eclipse-temurin:21-jdk

# definimos el directorio de trabajo
WORKDIR /app

# opiamos SOLO el archivo .jar generado en la etapa anterior
# usamos un comodín (*.jar) para que funcione sin importar el nombre exacto del proyecto
COPY --from=build /app/build/libs/*.jar app.jar

# puerto 8080
EXPOSE 8080

# Comando para ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]