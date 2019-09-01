FROM elixir:1.9-alpine

WORKDIR /usr/src/app

# Required to compile some Elixir libs (such as bcrypt)
RUN apk add make gcc libc-dev --no-cache

RUN addgroup -g 1000 docker \
    && adduser -D -G docker -u 1000 docker \
    && chown -R 1000:1000 .

USER docker

COPY --chown=docker:docker ./app ./
COPY --chown=docker:docker ./docker/app/start.sh /start.sh

RUN mix local.hex --force \
    && mix local.rebar --force

CMD ["/start.sh"]
