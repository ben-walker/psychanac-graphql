#!/bin/bash

function wait_for_postgres {
  while ! pg_isready --host=localhost --port=5432 --username=postgres; do
    sleep 1
  done
}

# Setup the environment
export DATABASE_URL="postgresql://postgres:password@localhost:5432"
export REDIS_URL="redis://:@localhost:6379"
export SECRET="oo6iP6dQRC/qm2WlUn3Tej+LocObV801"
export CORS_ORIGIN="https://studio.apollographql.com"

# Install node_modules if missing
[ ! -d "node_modules" ] && npm install

docker compose up --detach \
  && wait_for_postgres \
  && npm run prisma:db:sync \
  && npx concurrently --kill-others npm:*:dev
