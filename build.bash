CONTEXT_DIR=$(mktemp --directory)
MAIN_PACKAGES=$(go list -f '{{- if eq .Name "main"}}{{- .ImportPath}}{{"\n"}}{{- end}}' ./... | grep --perl-regexp '.+')
readarray -t MAIN_PACKAGES <<<${MAIN_PACKAGES}
for MAIN_PACKAGE in "${MAIN_PACKAGES[@]}"; do
	PROGRAM=$(basename "${MAIN_PACKAGE}")
	CGO_ENABLED=0 go build "${@}" -o "${CONTEXT_DIR}/bin/${PROGRAM}" "${MAIN_PACKAGE}"
done
if [[ -d etc ]]; then
	cp --recursive --no-target-directory etc "${CONTEXT_DIR}/etc"
fi

GIT_REPO_URL=$(git remote get-url origin)
GIT_COMMIT=$(git rev-parse HEAD)
GO_VERSION=$(go version | grep --perl-regexp --only-matching --max-count=1 '(?<=go)\d+\.\d+')
PROJECT=$(basename "${GIT_REPO_URL}" .git)
docker build --file=- --tag="${IMAGE}" "${CONTEXT_DIR}" <<EOF
FROM alpine:3.15

LABEL\
 git-repo-url=${GIT_REPO_URL@Q}\
 git-commit=${GIT_COMMIT@Q}\
 go-version=${GO_VERSION@Q}

ENV IMAGE=${IMAGE@Q}

COPY . /opt/${PROJECT@Q}
WORKDIR /opt/${PROJECT@Q}
EOF

rm --recursive --force "${CONTEXT_DIR}"

docker push "${IMAGE}"