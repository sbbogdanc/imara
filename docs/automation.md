## Automation

This project demonstrates Continuous Integration (CI), Continuous Training (CT) and Continuous Delivery (CD) to accelerate deployment of LLMs into production and delivery of GenAI applications. 

### Google Cloud

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

Create the necessary vertex deployer image and Cloud Deploy Custom Target Type.
```shell
git clone https://github.com/GoogleCloudPlatform/cloud-deploy-samples && \
cloud-deploy-samples/custom-targets/vertex-ai/build_and_register.sh -p $PROJECT_ID -r $REGION && \
rm -rf cloud-deploy-samples
```

#### Tutorial

##### Workflow

1. Review the Cloud Build [workflow]. 
2. Execute the [workflow] using Cloud Build.

```shell
gcloud builds submit --config .cloudbuild/cloudbuild.yaml
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