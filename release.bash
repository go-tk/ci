if [[ -z $(docker images --quiet --filter=reference="${BASE_IMAGE}") ]]; then
	docker pull "${BASE_IMAGE}"
fi

LABELS=()
LABELS+=("org.opencontainers.image.created=$(date --rfc-3339=date)")
LABELS+=("org.opencontainers.image.ref.name=${IMAGE}")
LABELS+=("org.opencontainers.image.base.digest=$(docker image inspect --format='{{index .RepoDigests 0}}' "${BASE_IMAGE}" | cut --delimiter=@ --fields=2)")
LABELS+=("org.opencontainers.image.base.name=${BASE_IMAGE}")
docker build --tag="${IMAGE}" "${LABELS[@]/#/--label=}" - <<EOF
FROM ${BASE_IMAGE}
ENV IMAGE=${IMAGE@Q}
EOF

docker push "${IMAGE}"
