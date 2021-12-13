#!/bin/sh

if [ "$1" = "start" ]; then
  mix setup
  exec mix phx.server
elif [ "$1" = "test" ]; then
  MIX_ENV=test mix test
else
  exec "$@"
fi
