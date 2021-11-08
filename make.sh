set -eu${DEBUG:+x}

DEBUG=${DEBUG:+1}
NDEBUG=$([ -n "${DEBUG}" ] || echo 1)
XPWD=${XPWD:-${PWD}}

docker run --user="$(id -u):$(id -g)" --rm --interactive --tty \
	--volume=/var/run/docker.sock:/var/run/docker.sock \
	--volume="${XPWD}:/workspace" \
	--workdir=/workspace \
	--env=DEBUG=${DEBUG} \
	--env=NDEBUG=${NDEBUG} \
	--env="XPWD=${XPWD}" \
	ghcr.io/go-tk/ci:v1.1.0 make "${@}"
