FROM ubuntu:18.04

LABEL "repository"="https://github.com/adoom2017/vaultwarden-tools" \
  "homepage"="https://github.com/adoom2017/vaultwarden-tools" \
  "maintainer"="adoom2017 <shendongchun08@gmail.com>"

# Latest releases available at https://github.com/aptible/supercronic/releases
ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.2.26/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=7a79496cf8ad899b99a719355d4db27422396735

RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y sqlite tzdata curl && mkdir -p /app && mkdir -p /vaultwarden/data \
 && mkdir -p /vaultwarden/backup \
 && curl -fsSLO "$SUPERCRONIC_URL" \
 && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
 && chmod +x "$SUPERCRONIC" \
 && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
 && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic

ENV TZ=Asia/Shanghai

COPY app/*.sh /app/

RUN chmod +x /app/*.sh

ENTRYPOINT ["/app/entrypoint.sh"]
