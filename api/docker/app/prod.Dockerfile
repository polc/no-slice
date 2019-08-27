FROM elixir:1.9-alpine AS builder

# Required to compile some Elixir libs (such as bcrypt)
RUN apk add make gcc libc-dev --no-cache

WORKDIR /tmp
ENV MIX_ENV "prod"

COPY ./app/mix.* ./
RUN mix local.hex --force \
    && mix local.rebar --force \
    && mix do deps.get, deps.compile

COPY ./app ./
RUN mix release

FROM alpine:3.9

RUN apk add ncurses-dev --no-cache
WORKDIR /usr/src/bio

RUN addgroup -g 1000 docker \
    && adduser -D -G docker -u 1000 docker \
    && chown -R 1000:1000 .
USER docker

COPY --from=builder --chown=docker:docker /tmp/_build .

CMD ["./prod/rel/default/bin/default", "start"]
