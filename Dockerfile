# --- ETAPA 1: Compilación y dependencias ---
FROM python:3.12-slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libc6-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

# Instalar dependencias en un directorio aislado
RUN pip install --no-cache-dir --user -r requirements.txt


# --- ETAPA 2: Entorno de ejecución seguro ---
FROM python:3.12-slim AS runner

WORKDIR /app

# Crear un usuario del sistema sin privilegios para no correr como root
RUN useradd -u 1001 devopsuser && \
    mkdir -p /app && \
    chown -R devopsuser:devopsuser /app

# Copiar las dependencias instaladas desde la etapa anterior
COPY --from=builder /root/.local /home/devopsuser/.local
COPY --from=builder /app /app

# Copiar el código fuente de la aplicación
COPY src/ ./src/

# Configurar variables de entorno indispensables
ENV PATH=/home/devopsuser/.local/bin:$PATH
ENV PYTHONUNBUFFERED=1
ENV PORT=5000

# Cambiar al usuario seguro
USER devopsuser

EXPOSE 5000

CMD ["python", "src/app.py"]
