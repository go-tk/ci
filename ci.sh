set -eu${DEBUG:+x}

DEBUG=${DEBUG:+1}
NDEBUG=$([ -z ${DEBUG} ] && echo 1 || true)

CI_IMAGE=roy2220/ci-box:v1
CI_CONTAINER_ID_FILE=.ci-container-id
CI_CONTAINER_TTL=7200
CI_UID=$(id -u)
CI_GID=$(id -g)
CI_CACHE_DIR=.ci-cache
CI_CACHE_TTL=172800
CI_GIT_REPO=https://github.com/go-tk/ci.git
CI_GIT_BRANCH=v1

if [ ! -f "${CI_CONTAINER_ID_FILE}" ] || [ -z "$(docker ps --quiet --filter="id=$(cat "${CI_CONTAINER_ID_FILE}")")" ]; then
	rm -f "${CI_CONTAINER_ID_FILE}"
	docker pull "${CI_IMAGE}"
	docker run --rm --detach \
		--volume=/var/run/docker.sock:/var/run/docker.sock \
		--volume="${PWD}:/workspace" \
		--workdir=/workspace \
		--cidfile="${CI_CONTAINER_ID_FILE}" \
		"${CI_IMAGE}" sleep "${CI_CONTAINER_TTL}"
	docker exec "$(cat "${CI_CONTAINER_ID_FILE}")" /bin/bash -eu${DEBUG:+x}o pipefail -c '
		sed --regexp-extended --in-place '\''s/^ci:x:[0-9]+/ci:x:'"${CI_UID}"'/'\'' /etc/group
		sed --regexp-extended --in-place '\''s/^ci:x:[0-9]+:[0-9]+/ci:x:'"${CI_UID}"':'"${CI_GID}"'/'\'' /etc/passwd
		chown '\'"${CI_UID}"':'"${CI_GID}"\'' /home/ci
	'
fi

docker exec --user=ci:ci --interactive --tty "$(cat "${CI_CONTAINER_ID_FILE}")" /bin/bash -eu${DEBUG:+x}o pipefail -c '
	create_ci_cache_dir() {
		export CI_CACHE_DIR
		CI_CACHE_DIR=$(realpath '\'${CI_CACHE_DIR}\'')
		local expiry_time_file=${CI_CACHE_DIR}/expiry-time
		if [[ -f "${expiry_time_file}" && "$(<"${expiry_time_file}")" -lt "$(date +%s)" ]]; then
			find "${CI_CACHE_DIR}" -type d ! -perm -u+rwx -exec chmod -u+rwx {} \;
			find "${CI_CACHE_DIR}" -mindepth 1 -maxdepth 1 ! -path "${expiry_time_file}" -exec rm --recursive --force {} \;
			rm "${expiry_time_file}"
		fi
		if [[ -f "${expiry_time_file}" ]]; then
			return
		fi
		mkdir --parents "${CI_CACHE_DIR}"
		date --date='\''+'"${CI_CACHE_TTL}"' seconds'\'' +%s > "${expiry_time_file}"
	}

	create_ci_dir() {
		export CI_DIR="${CI_CACHE_DIR}/ci.'"${CI_GIT_BRANCH}"'"
		if [[ -d "${CI_DIR}" ]]; then
			return
		fi
		git clone --branch '\'"${CI_GIT_BRANCH}"\'' --single-branch --depth=1 ${NDEBUG:+--quiet} '\'"${CI_GIT_REPO}"\'' "${CI_DIR}"
	}

	for ENV in "${@}"; do
		export "${ENV}"
	done
	unset ENV
	create_ci_cache_dir
	create_ci_dir
	source "${CI_DIR}/main.bash"
' -- "$@" DEBUG=${DEBUG} NDEBUG=${NDEBUG}
