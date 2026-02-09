FROM container-registry.oracle.com/database/express:21.3.0-xe

ENV LANG=ru_RU.UTF-8 \
    LANGUAGE=ru_RU:ru \
    LC_ALL=ru_RU.UTF-8

COPY ./Scripts /docker-entrypoint-initdb.d/

EXPOSE 1521 5500

LABEL maintainer="your-email@example.com" \
      description="Oracle Database 21c Express Edition для воркшопа" \
      version="1.0"