FROM elixir:1.9-alpine

# Mix need these variables at build time
ARG MIX_ENV
ARG APP_SECRET
ARG DATABASE_PORT
ARG DATABASE_HOST
ARG DATABASE_NAME
ARG DATABASE_USER
ARG DATABASE_PASSWORD

ENV MIX_ENV $MIX_ENV
ENV APP_SECRET $APP_SECRET
ENV DATABASE_PORT $DATABASE_PORT
ENV DATABASE_HOST $DATABASE_HOST
ENV DATABASE_NAME $DATABASE_NAME
ENV DATABASE_USER $DATABASE_USERNAME
ENV DATABASE_PASSWORD $DATABASE_PASSWORD

# Required to compile some Elixir libs (such as bcrypt)
RUN apk add make gcc libc-dev --no-cache

# Run the app using a non privilegied user
WORKDIR /usr/src/app

RUN addgroup -g 1000 docker \
    && adduser -D -G docker -u 1000 docker \
    && chown -R 1000:1000 .

USER docker

# Copy files
COPY --chown=docker:docker ./app ./
COPY --chown=docker:docker ./docker/app/start.sh /start.sh

# Get dependencies and compile them
RUN mix local.hex --force \
    && mix local.rebar --force \
    && mix deps.get \
    && mix compile

CMD ["/start.sh"]
