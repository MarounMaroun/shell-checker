FROM koalaman/shellcheck-alpine

RUN apk --no-cache add jq bash curl git git-lfs

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
