if [[ -z $(docker images --quiet --filter=reference="${BASE_IMAGE}") ]]; then
	docker pull "${BASE_IMAGE}"
fi

docker build \
	--tag="${IMAGE}" \
	--label=org.opencontainers.image.created="$(date --rfc-3339=date)" \
	--label=org.opencontainers.image.ref.name="${IMAGE}" \
	--label=org.opencontainers.image.base.digest="$(docker image inspect --format='{{index .RepoDigests 0}}' "${BASE_IMAGE}" | cut --delimiter=@ --fields=2)" \
	--label=org.opencontainers.image.base.name="${BASE_IMAGE}" \
	- <<EOF
FROM ${BASE_IMAGE}
ENV IMAGE=${IMAGE@Q}
EOF

docker push "${IMAGE}"
