# Azure Kubernetes Service CI/CD Demo

## Overview
This repo demonstrates how to deploy networking infrastructure, Azure Kubernetes Service (AKS) clusters and the Azure voting app across 3 environments, dev, test & prod.

Three ADO pipelines each deploy a separate layer of the solution:
- Base networking infrastructure: ./pipelines/infra-pipeline.yaml
- AKS clusters: ./pipelines/aks-pipeline.yaml
- Azure Voting app: ./pipelines/workload-pipeline.yaml

<img src="./images/pipelines_screenshot.png" alt="Pipelines" width="800"/>

<img src="./images/pipeline_stages_screenshot.png" alt="Pipelines" width="800"/>

## Pre-Requisites
- Azure DevOps Organization
- [Fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/about-forks) this repository into your own GitHub account
- Create an Azure DevOps [GitHub Service Connection](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml) to the forked repository
- Install the 'Run ARM TTK Tests (Cross Platform)' extension to your ADO project from the [Azure DevOps marketplace](https://marketplace.visualstudio.com)
- Create 3 pipelines from the ./pipelines/*-pipeline.yaml files, in the Azure Devops portal
  - 'Project' -> 'Pipelines' -> 'New Pipeline' -> 'GitHub' -> '(your forked GitHub repo name)/aks-cicd-demo' -> 'Existing Azure Pipelines YAML file'
  - Repeat the above process to browse for each of the existing pipeline files
    - ./pipelines/infra-main.yaml
    - ./pipelines/aks-main.yaml
    - ./pipelines/workload-main.yaml
  - Rename each pipeline from its auto-generated name to whatever you want, but the names below are suggested
    - infra-pipeline
    - aks-pipeline
    - workload-pipeline
- Create 3 environments in the Azure Devops portal
  - aks-cicd-demo-dev
  - aks-cicd-demo-test
  - aks-cicd-demo-prod

## Deployment
- run the ''