#!/bin/bash
set -e

# allow the container to be started with `--user`
if [[ "$*" == python*bot.py* ]] && [ "$(id -u)" = '0' ]; then
	chown -R user "$DEMIBOT_BRAIN_PATH"
	exec gosu user "$BASH_SOURCE" "$@"
fi

exec "$@"
