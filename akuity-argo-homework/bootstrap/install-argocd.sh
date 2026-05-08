#!/usr/bin/env bash
set -euo pipefail

ARGOCD_VERSION="stable"

echo "Creating argocd namespace..."
kubectl apply -f bootstrap/argocd-namespace.yaml

echo "Installing Argo CD..."
kubectl apply -n argocd -f "https://raw.githubusercontent.com/argoproj/argo-cd/${ARGOCD_VERSION}/manifests/install.yaml"

echo "Waiting for Argo CD pods..."
kubectl wait --for=condition=Ready pods --all -n argocd --timeout=300s

echo "Argo CD installed successfully."
kubectl get pods -n argocd
