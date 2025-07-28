#django application Dockerfile
FROM python:3.9 as builder

WORKDIR /app/backend

COPY requirements.txt /app/backend

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir -r requirements.txt

#----------------------------------------------------#

FROM python:3.9-slim

WORKDIR /app/backend

# Install system dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    libpq-dev \
    && apt-get install -y gcc default-libmysqlclient-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*

RUN pip install mysqlclient
RUN pip install gunicorn
COPY . /app/backend
COPY --from=builder /usr/local/lib/python3.9/site-packages/ /usr/local/lib/python3.9/site-packages/
COPY --from=builder /usr/local/bin/ /usr/local/bin/

EXPOSE 8000

#CMD ["python", "/app/backend/manage.py", "runserver", "0.0.0.0:8000"]
