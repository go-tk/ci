set -eu${DEBUG:+x}

DEBUG=${DEBUG:+1}
NDEBUG=$([ -n "${DEBUG}" ] || echo 1)
XPWD=${XPWD:-${PWD}}

docker run --user="$(id -u):$(id -g)" --rm --interactive $([ ! -t 1 ] || echo --tty) \
	--volume=/var/run/docker.sock:/var/run/docker.sock \
	--volume="${XPWD}:/workspace" \
	--workdir=/workspace \
	--env=DEBUG=${DEBUG} \
	--env=NDEBUG=${NDEBUG} \
	--env="XPWD=${XPWD}" \
	ghcr.io/go-tk/ci:v1.1.5 make ${DEBUG:+--trace} "${@}"
