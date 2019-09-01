#!/bin/sh

# install dependencies
mix deps.get

# start dev server
mix phx.server
