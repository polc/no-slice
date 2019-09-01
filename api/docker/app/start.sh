#!/bin/sh

set -e

# install dependencies
mix deps.get

# start dev server
mix phx.server
