#!/bin/bash

# Vérifie si Docker tourne
if ! docker info > /dev/null 2>&1; then
  echo "Docker ne tourne pas, démarre Docker Desktop puis relance."
  exit 1
fi

# Stoppe les conteneurs qui utilisent le port 7860
if lsof -i :7860 > /dev/null; then
  echo "Port 7860 occupé, arrêt des conteneurs sur ce port..."
  docker ps --filter "publish=7860" --format "{{.ID}}" | xargs -r docker stop
fi

# Lance le container
docker run --rm -it \
  -p 7860:7860 \
  -v "$(pwd)":/home/app \
  -w /home/app \
  -e PORT=7860 \
  -e BACKEND_STORE_URI="${BACKEND_STORE_URI}" \
  -e ARTIFACT_STORE_URI="${ARTIFACT_STORE_URI}" \
  -e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
  -e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
  -e MLFLOW_TRACKING_URI=http://localhost:7860 \
  mon-image-mlflow
