MAKEFILES=("${@}")
DEFAULT_TARGETS=$(sed --regexp-extended --silent 's/^default:\s*(.+)/\1/p' "${MAKEFILES[@]}" | tr '\n' ' ')
TARGET_COMMENTS=$(grep --perl-regexp --context=0 --group-separator='' --no-filename '^##( |$)' "${MAKEFILES[@]}" | cut --characters=4-)

cat <<EOF
default: ${DEFAULT_TARGETS}

${TARGET_COMMENTS}

help:
    Show this message.
EOF
