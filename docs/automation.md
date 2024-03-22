## Automation

This project demonstrates Continuous Integration (CI), Continuous Training (CT) and Continuous Delivery (CD) to accelerate deployment of LLMs into production and delivery of GenAI applications. 

#### Overview

This project uses a suite of Google Cloud products to facilitate CI/CT/CD of the [PaLM 2 Text Bison] model, including:
* [Cloud Build] for automating the pipeline.
* [Cloud Storage] for storing data.
* [Vertex AI] for fine tuning models.
* [Artifact Registry] for storing artifacts.
* [Cloud Deploy] for deploying models. 

Upon any code or data changes in this repository, Cloud Build triggers the execution of the [workflow], ensuring efficient and reliable GenAI application development and delivery.

#### Setup

In addition to the basic [SETUP], the following setup needs to be done for Cloud Deploy integration.

1. Grant the necessary permissions to the default Compute Service Account:

    ```shell
    gcloud projects add-iam-policy-binding $PROJECT_ID \
      --member=serviceAccount:$(gcloud projects describe $PROJECT_ID \
      --format="value(projectNumber)")-compute@developer.gserviceaccount.com \
      --role="roles/clouddeploy.jobRunner"

    gcloud projects add-iam-policy-binding $PROJECT_ID \
      --member=serviceAccount:$(gcloud projects describe $PROJECT_ID \
      --format="value(projectNumber)")-compute@developer.gserviceaccount.com \
      --role="roles/clouddeploy.viewer"
    ```

1. Grant the necessary permissions to the default Cloud Build Service Account: 

    ```shell
    gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member=serviceAccount:$(gcloud projects describe $PROJECT_ID \
        --format="value(projectNumber)")@cloudbuild.gserviceaccount.com \
        --role="roles/aiplatform.user"

    gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member=serviceAccount:$(gcloud projects describe $PROJECT_ID \
        --format="value(projectNumber)")@cloudbuild.gserviceaccount.com \
        --role="roles/serviceusage.serviceUsageViewer"

    gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member=serviceAccount:$(gcloud projects describe $PROJECT_ID \
        --format="value(projectNumber)")@cloudbuild.gserviceaccount.com \
        --role="roles/clouddeploy.releaser"

    gcloud iam service-accounts add-iam-policy-binding $(gcloud projects describe $PROJECT_ID \
        --format="value(projectNumber)")-compute@developer.gserviceaccount.com \
        --member=serviceAccount:$(gcloud projects describe $PROJECT_ID \
        --format="value(projectNumber)")@cloudbuild.gserviceaccount.com \
        --role="roles/iam.serviceAccountUser" \
        --project=$PROJECT_ID
    ```

1. Create the necessary VertexAI Custom Target Image and Cloud Deploy Custom Target Type:

    ```shell
    git clone https://github.com/GoogleCloudPlatform/cloud-deploy-samples
    cloud-deploy-samples/custom-targets/vertex-ai/build_and_register.sh -p $PROJECT_ID -r $REGION
    rm -rf cloud-deploy-samples
    ```

1. Create the necessary dev and staging endpoints:
    
    ```shell
    export MODEL_DISPLAY_NAME=rlhf-tuned-text-bison

    gcloud ai endpoints create \
        --project="$PROJECT_ID" \
        --region="$REGION" \
        --display-name="$MODEL_DISPLAY_NAME-dev-endpoint"

    gcloud ai endpoints create \
        --project="$PROJECT_ID" \
        --region="$REGION" \
        --display-name="$MODEL_DISPLAY_NAME-staging-endpoint"
    ```

1. Save the endpoints into their respective variables:

    ```shell
    export DEV_ENDPOINT_ID=`gcloud ai endpoints list \
        --project="$PROJECT_ID" \
        --region="$REGION" \
        --filter="DISPLAY_NAME: $MODEL_DISPLAY_NAME-dev-endpoint" \
        --sort-by=~creationTimestamp \
        --limit=1 \
        --format="flattened(name)" \
        | awk '{print $2}' | tr -d '\n' | sed 's:.*/::'`

    export STAGING_ENDPOINT_ID=`gcloud ai endpoints list \
        --project="$PROJECT_ID" \
        --region="$REGION" \
        --filter="DISPLAY_NAME: $MODEL_DISPLAY_NAME-staging-endpoint" \
        --sort-by=~creationTimestamp \
        --limit=1 \
        --format="flattened(name)" \
        | awk '{print $2}' | tr -d '\n' | sed 's:.*/::'`
    ```

1. Navigate to the root of the `imara/` repository:

    ```shell
    cd $(git rev-parse --show-toplevel)
    ```

1. Run the command to create the clouddeploy.yaml file:

    ```shell
    cat <<EOF > deploy/clouddeploy.yaml
    apiVersion: deploy.cloud.google.com/v1
    kind: DeliveryPipeline
    metadata:
      name: vertex-ai-cloud-deploy-pipeline
    serialPipeline:
      stages:
      - targetId: dev-endpoint
        strategy:
          standard:
            postdeploy:
              actions: ["add-aliases"]
      - targetId: staging-endpoint
        strategy:
          standard:
            postdeploy:
              actions: ["add-aliases"]
    ---
    apiVersion: deploy.cloud.google.com/v1
    kind: Target
    metadata:
      name: dev-endpoint
    customTarget:
      customTargetType: vertex-ai-endpoint
    deployParameters:
      customTarget/vertexAIEndpoint: "projects/$PROJECT_ID/locations/$REGION/endpoints/$DEV_ENDPOINT_ID"
      customTarget/vertexAIConfigurationPath: "dev/deployedModel.yaml"
      customTarget/vertexAIMinReplicaCount: "3"
      customTarget/vertexAIAliases: "dev"
    ---
    apiVersion: deploy.cloud.google.com/v1
    kind: Target
    requireApproval: true
    metadata:
      name: staging-endpoint
    customTarget:
      customTargetType: vertex-ai-endpoint
    deployParameters:
      customTarget/vertexAIEndpoint: "projects/$PROJECT_ID/locations/$REGION/endpoints/$STAGING_ENDPOINT_ID"
      customTarget/vertexAIConfigurationPath: "staging/deployedModel.yaml"
      customTarget/vertexAIMinReplicaCount: "3"
      customTarget/vertexAIAliases: "staging,champion"
    EOF
    ```

1. Apply the Cloud Deploy configuration to create Cloud Deploy resources:

    ```shell
    gcloud deploy apply \
      --file="deploy/clouddeploy.yaml" \
      --project=$PROJECT_ID \
      --region=$REGION
    ```

#### Tutorial

##### Workflow

1. Review the Cloud Build [workflow].
1. Navigate to the root of the `imara/` repository.

    ```shell
    cd $(git rev-parse --show-toplevel)
    ```

1. Execute the [workflow] using Cloud Build.

    ```shell
    gcloud builds submit \
        --config .cloudbuild/cloudbuild.yaml \
        --project=$PROJECT_ID \
        --region=$REGION
    ```

##### Triggers

This is guide for setting up your own automation on your fork of this repository. 

1. [Fork] the jerop/imara repository.
1. [Connect] Cloud Build to your fork.
1. Create a Cloud Build [trigger].
2. [Clone] the fork and push a commit to trigger the [workflow] execution.


[Vertex AI]: https://cloud.google.com/vertex-ai
[Artifact Registry]: https://cloud.google.com/artifact-registry
[Cloud Build]: https://cloud.google.com/build
[Cloud Deploy]: https://cloud.google.com/deploy
[Cloud Storage]: https://cloud.google.com/storage
[PaLM 2 Text Bison]: https://cloud.google.com/vertex-ai/docs/generative-ai/model-reference/text
[fork]: https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo#forking-a-repository
[connect]: https://cloud.google.com/build/docs/automating-builds/create-manage-triggers#console
[trigger]: https://cloud.google.com/build/docs/automating-builds/create-manage-triggers#build_trigger
[clone]: https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo#cloning-your-forked-repository
[workflow]: /.cloudbuild/cloudbuild.yaml
[SETUP]: SETUP.md
