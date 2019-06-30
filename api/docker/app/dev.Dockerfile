FROM elixir:1.9-alpine

WORKDIR /usr/src/app

# Required to compile some Elixir libs (such as bcrypt)
RUN apk add make gcc libc-dev --no-cache

RUN addgroup -g 1000 docker \
    && adduser -D -G docker -u 1000 docker \
    && chown -R 1000:1000 .

USER docker

COPY --chown=docker:docker ./app/mix.* ./

RUN mix local.hex --force \
    && mix local.rebar --force \
    && mix do deps.get
    #, deps.compile, compile

COPY --chown=docker:docker ./app ./

CMD ["mix", "phx.server"]
