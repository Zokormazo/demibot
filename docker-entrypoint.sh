#!/bin/sh
set -e

exec gosu user "$@"
