# ====== STAGE 1: BUILD ======
FROM maven:3.9.6-eclipse-temurin-21 AS builder

WORKDIR /app

COPY pom.xml . 
COPY src ./src

RUN mvn clean package -DskipTests

# ====== STAGE 2: RUN ======
FROM eclipse-temurin:21-jdk

# 🔥 Librerías necesarias para JasperReports + fonts + AWT
RUN apt-get update && apt-get install -y \
    libfreetype6 \
    libfreetype6-dev \
    fontconfig \
    fonts-dejavu \
    fonts-dejavu-core \
    fonts-dejavu-extra \
    libxrender1 \
    libxext6 \
    libx11-6 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copia el jar generado
COPY --from=builder /app/target/*.jar app.jar

# 🔥 Java en modo headless (OBLIGATORIO para JasperReports)
ENV JAVA_TOOL_OPTIONS="-Djava.awt.headless=true"
ENV _JAVA_OPTIONS="-Djava.awt.headless=true"

# Puerto de Railway
EXPOSE 8080

# Ejecutar aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]