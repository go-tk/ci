set -eu${DEBUG:+x}

DEBUG=${DEBUG:+1}
NDEBUG=$([ -n "${DEBUG}" ] || echo 1)
if [ -t 1 ]; then TTY=1; else TTY=; fi
XPWD=${XPWD:-${PWD}}

docker run --user="$(id -u):$(id -g)" --rm --interactive ${TTY:+--tty} \
	--volume=/var/run/docker.sock:/var/run/docker.sock \
	--volume="${XPWD}:${PWD}" \
	--workdir="${PWD}" \
	--env=DEBUG=${DEBUG} \
	--env=NDEBUG=${NDEBUG} \
	--env="XPWD=${XPWD}" \
	ghcr.io/go-tk/ci:v1.3.1 make ${DEBUG:+--trace} "${@}"
