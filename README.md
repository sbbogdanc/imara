# GenAI application development and deployment with Google Cloud Platform

The following demonstrates GenAI application development within the Google Cloud Platform, including:

* **Model tuning**. Tuning of Google and Hugging Face foundation models using Reinforcement Learning from Human Feedback (RLHF) in Vertex AI.
* **ML Operations**. Automating Continuous Integration (CI), Continuous Training (CT) and Continuous Delivery (CD) for machine learning operations ('MLOps'). This automation streamlines the development and deployment processes, ensuring efficient and reliable model updates to deliver value to users more quickly.

## Setup

To begin, follow the [setup](/docs/SETUP.md) guide to configure a project, service accounts, permissions, storage and more.

## Develop

Jupyter notebooks provide a highly interactive environment for model development which supports iterative refinement of machine learning models.

This project provides several notebooks:
1. [Bison Notebook](text-bison-notebook.ipynb): demonstrates fine tuning a [PaLM 2 Text Bison] model from Vertex AI [Model Garden].
2. (Coming Soon) T5 Notebook: demonstrates fine tuning the [Text-To-Text Transfer Transformer] model from [Hugging Face].

The notebooks can be executed locally or on Vertex AI through Vertex AI [Workbench].

#### Vertex AI Workbench

To use Vertex AI Workbench:

1. [Create][vertex-wb] a Vertex AI Workbench instance.
1. [Clone][vertex-wb-git] this GitHub repository in your instance. 
1. Open a notebook within your Vertex AI Workbench instance and execute the steps.

## Deploy

The following demonstrates MLOps Continuous Integration (CI), Continuous Training (CT) and Continuous Delivery (CD) to accelerate deployment of LLM models into production for use with GenAI applications.

This project uses a suite of Google Cloud products to facilitate CI/CT/CD of the [PaLM 2 Text Bison] model, including:

* [Cloud Build] for automating the pipeline.
* [Cloud Storage] for storing data.
* [Vertex AI] for fine tuning models.
* [Artifact Registry] for storing artifacts.
* [Cloud Deploy] for deploying models. 

To begin, follow the [automation](/docs/automation.md) guide to configure a project, service accounts, permissions, storage and more.

[Model Garden]: https://cloud.google.com/vertex-ai/docs/start/explore-models
[Workbench]: https://cloud.google.com/vertex-ai/docs/workbench/introduction
[Colab Enterprise]: https://cloud.google.com/vertex-ai/docs/colab/create-console-quickstart
[Hugging Face]: https://huggingface.co/
[Text-To-Text Transfer Transformer]: https://huggingface.co/google-t5/t5-small 
[vertex-wb]: https://cloud.google.com/vertex-ai/docs/workbench/instances/create#consol
[vertex-wb-git]: https://cloud.google.com/vertex-ai/docs/workbench/instances/save-to-github#clone-a-repo
[Vertex AI]: https://cloud.google.com/vertex-ai
[Artifact Registry]: https://cloud.google.com/artifact-registry
[Cloud Build]: https://cloud.google.com/build
[Cloud Deploy]: https://cloud.google.com/deploy
[Cloud Storage]: https://cloud.google.com/storage
[PaLM 2 Text Bison]: https://cloud.google.com/vertex-ai/docs/generative-ai/model-reference/text
[GitHub Actions]: https://docs.github.com/en/actions
