set -eu${DEBUG:+x}

DEBUG=${DEBUG:+1}
NDEBUG=$([ -n "${DEBUG}" ] || echo 1)

COMMAND='docker run --user="$(id -u):$(id -g)" --rm --interactive'

if [ -t 1 ]; then
	COMMAND=${COMMAND}' --tty'
fi

COMMAND=${COMMAND}' \
--volume=/var/run/docker.sock:/var/run/docker.sock \
--volume="${XPWD:-${PWD}}:${PWD}" \
--workdir="${PWD}" \
--env=DEBUG=${DEBUG} \
--env=NDEBUG=${NDEBUG}'

if [ -f "${HOME}/.docker/config.json" ]; then
	COMMAND=${COMMAND}' \
--volume="${HOME}/.docker/config.json:/etc/docker/config.json" \
--env=DOCKER_CONFIG=/etc/docker'
fi

COMMAND=${COMMAND}' ghcr.io/go-tk/ci:v1.4.0 make ${DEBUG:+--trace} "${@}"'

eval "${COMMAND}"
