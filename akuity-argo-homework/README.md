# Akuity Technical Support Engineer Take-Home Challenge

This repository is a clean GitOps solution for the Akuity Technical Support Engineer take-home challenge.

## Objective

This repo demonstrates how to deploy and manage Argo CD using GitOps, monitor Argo CD with Prometheus, configure dashboards and alerts, and replace the Helm binary bundled with Argo CD with a different Helm version.

## Repository Structure

```text
akuity-argo-homework/
├── README.md
├── bootstrap/
│   ├── install-argocd.sh
│   └── argocd-namespace.yaml
├── argocd/
│   ├── root-app.yaml
│   ├── argocd-cm.yaml
│   ├── argocd-rbac-cm.yaml
│   └── custom-helm-version-patch.yaml
├── apps/
│   ├── prometheus-application.yaml
│   └── monitoring-config/
│       ├── servicemonitor.yaml
│       ├── prometheus-rules.yaml
│       └── dashboards/
│           └── argocd-dashboard.json
├── docs/
│   ├── gitops-flow.md
│   └── troubleshooting.md
└── diagrams/
    └── gitops-end-to-end-flow.md
```

## Prerequisites

- Kubernetes cluster such as kind, minikube, EKS, AKS, or GKE
- kubectl configured to point to the cluster
- Git repository where these files are stored
- Argo CD CLI, optional but useful for testing

## Deployment Steps

### 1. Create the Argo CD namespace

```bash
kubectl apply -f bootstrap/argocd-namespace.yaml
```

### 2. Install Argo CD

```bash
bash bootstrap/install-argocd.sh
```

### 3. Update the Git repo URL

Edit these files and replace the placeholder repo URL with your GitHub repo URL:

```text
argocd/root-app.yaml
apps/prometheus-application.yaml
```

Replace:

```text
https://github.com/YOUR_USERNAME/akuity-argo-homework.git
```

with your real repository URL.

### 4. Apply the root app

```bash
kubectl apply -f argocd/root-app.yaml
```

### 5. Validate Argo CD applications

```bash
kubectl get applications -n argocd
kubectl get pods -n argocd
```

### 6. Validate Prometheus monitoring

```bash
kubectl get pods -n monitoring
kubectl get servicemonitor -A
kubectl get prometheusrule -A
```

## What This Solution Covers

### Part 1

1. Argo CD manages its own configuration and lifecycle through the root app pattern.
2. Prometheus is deployed using an Argo CD Application.
3. ServiceMonitor and PrometheusRule resources are included for Argo CD monitoring.
4. A custom Helm binary replacement approach is documented through an Argo CD repo-server init container patch.

### Part 2

The end-to-end GitOps auto-sync workflow is documented in:

```text
docs/gitops-flow.md
```

## Assumptions

- The cluster supports Kubernetes CRDs.
- Prometheus Operator CRDs are installed by the kube-prometheus-stack chart.
- Argo CD is installed in the `argocd` namespace.
- Prometheus/Grafana monitoring is installed in the `monitoring` namespace.
- The Helm replacement is demonstrated using an init container and shared volume pattern.

## Real-World Troubleshooting Notes

Troubleshooting details are included in:

```text
docs/troubleshooting.md
```


