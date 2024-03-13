#!/bin/bash

export _CT_IMAGE_NAME=vertexai

usage() {
  echo "usage: replace_variables.sh -p <project_id> -r <region> -d <dev_endpoint> -s <staging_endpoint> -t <tmp_dir>"
}

while getopts "p:r:d:s:t:" arg; do
  case "${arg}" in
    p)
      PROJECT="${OPTARG}"
      ;;
    r)
      REGION="${OPTARG}"
      ;;
    d)
      DEV_ENDPOINT="${OPTARG}"
      ;;
    s)
      STAGING_ENDPOINT="${OPTARG}"
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

if [[ ! -v PROJECT || ! -v REGION || ! -v DEV_ENDPOINT || ! -v STAGING_ENDPOINT || ! -v TMPDIR ]]; then
  usage
  exit 1
fi

# get the location where the custom image was uploaded
AR_REPO=$REGION-docker.pkg.dev/$PROJECT/cd-custom-targets

# get the image digest of the most recently built image
IMAGE_SHA=$(gcloud -q artifacts docker images describe "${AR_REPO}/${_CT_IMAGE_NAME}:latest" --format 'get(image_summary.digest)')


cp deploy/clouddeploy.yaml "$TMPDIR"/clouddeploy.yaml
cp -r deploy/configuration "$TMPDIR"/configuration

# replace variables in clouddeploy.yaml with actual values
sed -i "s/\$PROJECT_ID/${PROJECT}/g" "$TMPDIR"/clouddeploy.yaml
sed -i "s/\$REGION/${REGION}/g" "$TMPDIR"/clouddeploy.yaml
sed -i "s/\$DEV_ENDPOINT_ID/${DEV_ENDPOINT}/g" "$TMPDIR"/clouddeploy.yaml
sed -i "s/\$STAGING_ENDPOINT_ID/${STAGING_ENDPOINT}/g" "$TMPDIR"/clouddeploy.yaml

# replace variables in configuration/skaffold.yaml with actual values
sed -i "s/\$REGION/${REGION}/g" "$TMPDIR"/configuration/skaffold.yaml
sed -i "s/\$PROJECT_ID/${PROJECT}/g" "$TMPDIR"/configuration/skaffold.yaml
sed -i "s/\$_CT_IMAGE_NAME/${_CT_IMAGE_NAME}/g" "$TMPDIR"/configuration/skaffold.yaml
sed -i "s/\$IMAGE_SHA/${IMAGE_SHA}/g" "$TMPDIR"/configuration/skaffold.yaml
