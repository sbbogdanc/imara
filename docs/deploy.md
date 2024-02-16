# Deploy

[Cloud Deploy](https://cloud.google.com/deploy) makes continuous delivery of models easy by allowing users to define releases and progress them through environments such as test, stage, and production. It provides easy promotion, approval and rollback of releases. 


## Deploy Model (draft)

Deploy your model to the production endpoint using Cloud Deploy. 

The Vertex AI model deployer image is required for deploying your model to a production endpoint through Cloud Deploy. Before proceeding, ensure you have a Vertex AI model deployer image. If you already have one, you can proceed. If not, consult this [guide] to build and publish the image. 

[guide]: https://github.com/GoogleCloudPlatform/cloud-deploy-samples/blob/11731ca9481020ca7c1f6efa2d546e8dee9c6823/custom-targets/vertex-ai/README.md#building-the-sample-image
