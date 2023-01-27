if [[ -z $(docker images --quiet --filter=reference="${BASE_IMAGE}") ]]; then
	docker pull "${BASE_IMAGE}"
fi

COMMAND=(docker build --tag="${IMAGE}")
COMMAND+=(--label="org.opencontainers.image.created=$(date --rfc-3339=date)")
COMMAND+=(--label="org.opencontainers.image.ref.name=${IMAGE}")
COMMAND+=(--label="org.opencontainers.image.base.digest=$(docker image inspect --format='{{index .RepoDigests 0}}' "${BASE_IMAGE}" | cut --delimiter=@ --fields=2)")
COMMAND+=(--label="org.opencontainers.image.base.name=${BASE_IMAGE}")
COMMAND+=(-)
"${COMMAND[@]}" <<EOF
FROM ${BASE_IMAGE}
ENV IMAGE=${IMAGE@Q}
EOF

docker push "${IMAGE}"
