#!/bin/bash

BINARY="sonweb"

# List of platforms we build binaries for at this time:
PLATFORMS="linux/amd64"                 # Linux x86_64
PLATFORMS="$PLATFORMS linux/arm"        # ARM; 32bit

for PLATFORM in $PLATFORMS; do
  GOOS=${PLATFORM%/*}
  GOARCH=${PLATFORM#*/}
  BIN_FILENAME="${BINARY}-${GOOS}-${GOARCH}"
  if [[ "${GOOS}" == "windows" ]]; then BIN_FILENAME="${BIN_FILENAME}.exe"; fi
  CMD="CGO_ENABLED=0 GO_EXTLINK_ENABLED=0 GOOS=${GOOS} GOARCH=${GOARCH} go build -o ${BIN_FILENAME} -tags netgo -installsuffix netgo ."
  echo "${CMD}"
  eval $CMD || FAILURES="${FAILURES} ${PLATFORM}"
done

# eval errors
if [[ "${FAILURES}" != "" ]]; then
  echo ""
  echo "${BINARY} build failed on: ${FAILURES}"
  exit 1
fi
