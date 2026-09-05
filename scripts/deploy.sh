#!/bin/sh
set -e

WORKDIR="$(pwd)"
PREVIOUS_FILE="$WORKDIR/.previous_version"
CURRENT_FILE="$WORKDIR/.current_version"

VERSION="${VERSION:-latest}"
IMAGE="${IMAGE:-deploy-kimi1}"

export VERSION
export IMAGE

# Save currently running version as previous for rollback
if [ -f "$CURRENT_FILE" ]; then
  cp "$CURRENT_FILE" "$PREVIOUS_FILE"
fi

echo "Deploying $IMAGE:$VERSION"

# Pull latest image and start container idempotently
docker-compose pull app || true
docker-compose up -d

# Persist current version
echo "$VERSION" > "$CURRENT_FILE"

# Local health check
for i in $(seq 1 30); do
  if curl -sf http://localhost:3000/health > /dev/null; then
    echo "Health check passed for $IMAGE:$VERSION"
    exit 0
  fi
  sleep 1
done

# Rollback to previous version if available
if [ -f "$PREVIOUS_FILE" ]; then
  PREVIOUS_VERSION="$(cat "$PREVIOUS_FILE")"
  echo "Health check failed. Rolling back to $IMAGE:$PREVIOUS_VERSION"
  VERSION="$PREVIOUS_VERSION" docker-compose up -d

  for i in $(seq 1 30); do
    if curl -sf http://localhost:3000/health > /dev/null; then
      echo "Rollback health check passed"
      exit 1
    fi
    sleep 1
  done
  echo "Rollback failed"
fi

exit 1
