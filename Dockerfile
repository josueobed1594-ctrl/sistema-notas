# ====== STAGE 1: BUILD ======
FROM maven:3.9.6-eclipse-temurin-21 AS builder

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

# ====== STAGE 2: RUN ======
FROM eclipse-temurin:21-jdk

# 🔥 IMPORTANTÍSIMO: dependencias gráficas para JasperReports
RUN apt-get update && apt-get install -y \
    fontconfig \
    fonts-dejavu \
    libfreetype6 \
    libxrender1 \
    libxtst6 \
    libxi6 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /app/target/*.jar app.jar

# 👇 esto es correcto aquí
ENV JAVA_TOOL_OPTIONS="-Djava.awt.headless=true"

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]