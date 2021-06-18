set_go_environment_variables() {
	local go_version
	go_version=$(sed --regexp-extended --quiet 's/.*([0-9]+)\.([0-9]+)\.[0-9]+.*/\1.\2/p' /usr/local/go/VERSION)
	local go_cache_dir=${CI_CACHE_DIR}/go-${go_version}
	export GOMODCACHE=${go_cache_dir}/mod
	export GOBIN=$(go env GOPATH)/bin
}

install_alpine_packages() {
	if [[ -z ${ALPINE_PACKAGES:-} ]]; then
		return
	fi
	_set_alpine_mirror
	local apk_cache_dir
	apk_cache_dir=$(_create_apk_cache_dir)
	sudo apk add --no-progress ${NDEBUG:+--quiet} ${ALPINE_PACKAGES}
	find "${apk_cache_dir}" ! \( -user "$(id --user)" -group "$(id --group)" \) -exec sudo chown "$(id --user):$(id --group)" {} \;
}

_set_alpine_mirror() {
	if [[ -z ${ALPINE_MIRROR:-} ]]; then
		return
	fi
	sed --regexp-extended --in-place "s|https?://([^/]+)|${ALPINE_MIRROR}|g" /etc/apk/repositories
}

_create_apk_cache_dir() {
	local alpine_version
	alpine_version=$(sed --regexp-extended --quiet 's/.*([0-9]+)\.([0-9]+)\.[0-9]+.*/\1.\2/p' /etc/alpine-release)
	local apk_cache_dir=${CI_CACHE_DIR}/apk-${alpine_version}
	if [[ ! -d "${apk_cache_dir}" ]]; then
		mkdir --parents "${apk_cache_dir}"
	fi
	if [[ ! -d /etc/apk/cache ]]; then
		ln --symbolic "${apk_cache_dir}" /etc/apk/cache
	fi
	echo "${apk_cache_dir}"
}

make_goals() {
	if [[ -n ${PRE_MAKE:-} ]]; then
		${PRE_MAKE}
	fi
	if [[ -n ${POST_MAKE:-} ]]; then
		trap "${POST_MAKE}" EXIT
	fi
	make --no-builtin-rules --no-builtin-variables --file="${CI_DIR}/main.mk" ${DEBUG:+--debug} -- ${MAKE_GOALS:-}
}

set_go_environment_variables
install_alpine_packages
make_goals
