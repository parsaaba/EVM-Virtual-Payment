#!/usr/bin/env bash

# Exit script as soon as a command fails.
set -o errexit

# Executes cleanup function at script exit.
trap stop_ganache EXIT

ganache_running() {
  nc -z localhost 8545
}

start_ganache() {
  node_modules/.bin/ganache-cli --gasLimit 0xfffffffffff -e 1000000 > /dev/null &
  ganache_pid=$!
}

stop_ganache() {
  # Kill the ganache instance that we started (if we started one and if it's still running).
  if [ -n "$ganache_pid" ] && ps -p $ganache_pid > /dev/null; then
    kill -9 $ganache_pid
  fi
}

if ! ganache_running; then
  echo "Starting ganache instance..."
  echo "============================"
  start_ganache
fi

truffle version

node_modules/.bin/truffle test "$@"
