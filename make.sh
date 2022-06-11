set -eu${DEBUG+x}

COMMAND='docker run --user="$(id -u):$(id -g)" --rm --interactive'

if [ -t 1 ]; then
	COMMAND=${COMMAND}' --tty'
fi

COMMAND=${COMMAND}'\
 --volume=/var/run/docker.sock:/var/run/docker.sock\
 --volume="${XPWD:-${PWD}}:${PWD}"\
 --workdir="${PWD}"\
${DEBUG+ --env=DEBUG=}

if [ -f "${HOME}/.docker/config.json" ]; then
	COMMAND=${COMMAND}' \
--volume="${HOME}/.docker/config.json:/etc/docker/config.json" \
--env=DOCKER_CONFIG=/etc/docker'
fi

COMMAND=${COMMAND}' ghcr.io/go-tk/ci:v1.5.2 make ${DEBUG+--trace} "${@}"'

${COMMAND}
