#!/bin/bash
set -e

export _CT_IMAGE_NAME=vertexai

usage() {
  echo "usage: replace_variables.sh -p <project_id> -r <region> -t <tmp_dir>"
}

while getopts "p:r:t:" arg; do
  case "${arg}" in
    p)
      PROJECT="${OPTARG}"
      ;;
    r)
      REGION="${OPTARG}"
      ;;
    t)
      TMPDIR="${OPTARG}"
      ;;
    *)
      usage
      exit 1
      ;;
  esac
done

if [[ ! -v PROJECT || ! -v REGION || ! -v TMPDIR ]]; then
  usage
  exit 1
fi

# get the location where the custom image was uploaded
AR_REPO=$REGION-docker.pkg.dev/$PROJECT/cd-custom-targets

# get the image digest of the most recently built image
IMAGE_SHA=$(gcloud -q artifacts docker images describe "${AR_REPO}/${_CT_IMAGE_NAME}:latest" --format 'get(image_summary.digest)')

cp -r deploy/configuration "$TMPDIR"/configuration
# replace variables in configuration/skaffold.yaml with actual values
sed -i "s/\$REGION/${REGION}/g" "$TMPDIR"/configuration/skaffold.yaml
sed -i "s/\$PROJECT_ID/${PROJECT}/g" "$TMPDIR"/configuration/skaffold.yaml
sed -i "s/\$_CT_IMAGE_NAME/${_CT_IMAGE_NAME}/g" "$TMPDIR"/configuration/skaffold.yaml
sed -i "s/\$IMAGE_SHA/${IMAGE_SHA}/g" "$TMPDIR"/configuration/skaffold.yaml
