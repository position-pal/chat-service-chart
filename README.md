# Position Pal Helm Starter

This repository contains a Helm starter chart for the PositionPal Project. It provides a template for creating Helm charts to deploy applications on Kubernetes.

## Features

- Pre-configured templates for common Kubernetes resources such as Deployment, Service, Ingress, and more.
- Configurable service account, image pull secrets, and resource limits.
- Liveness and readiness probes.
- Customizable Helm values.

## Usage

### Prerequisites

- Helm 3.x installed on your local machine. You can follow the [Helm installation guide](https://helm.sh/docs/intro/install/) if you don't have it installed.

### Using the Starter

Use the [Salesforce Helm Starter Plugin](https://github.com/salesforce/helm-starter) for creating a new Helm chart using this starter.

1. Fetch this repository:

    ```sh
    helm starter fetch https://github.com/position-pal/pp-helm-starter.git
    ```

2. Create a new chart using this starter:

    ```sh
    helm create <CHART_NAME> --starter pp-helm-starter
    ```
