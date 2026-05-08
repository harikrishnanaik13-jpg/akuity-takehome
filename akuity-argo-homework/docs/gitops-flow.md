# End-to-End GitOps Auto-Sync Flow in Argo CD

This document explains what happens when an Argo CD Application watches Kubernetes manifests in Git and a new update is auto-synced to the cluster.

## Main Components

- Git server: Stores the desired Kubernetes manifests.
- argocd-server: Provides the UI, API, CLI endpoint, authentication, and user-facing access.
- application-controller: Watches Argo CD Applications and compares desired state from Git with live state in Kubernetes.
- repo-server: Clones Git repositories and renders manifests, including Helm, Kustomize, Jsonnet, and plain YAML.
- Kubernetes API server: Receives apply/update/delete requests and stores cluster state.

## Step-by-Step Flow

1. A developer changes Kubernetes manifests and pushes a commit to the Git repository.
2. Argo CD detects the Git change through polling or webhook notification.
3. The application-controller starts reconciliation for the affected Application.
4. The application-controller asks the repo-server to fetch the target revision from Git.
5. The repo-server clones or refreshes the repository cache.
6. The repo-server renders the manifests. If Helm is used, repo-server runs Helm template rendering.
7. The application-controller compares the rendered desired state with the live Kubernetes state.
8. If the desired state and live state are different, the Application becomes OutOfSync.
9. Because auto-sync is enabled, the application-controller applies the desired manifests through the Kubernetes API server.
10. The Kubernetes API server validates and persists the requested changes.
11. Kubernetes controllers create, update, or delete workloads such as Deployments, Services, ConfigMaps, Secrets, and CRDs.
12. Argo CD watches the live state until resources report healthy status.
13. The Application returns to Synced and Healthy when the live state matches Git and health checks pass.

## Component Interaction Diagram

```text
Developer
   |
   | git push
   v
Git Server
   |
   | webhook/polling
   v
Application Controller ---- asks for manifests ----> Repo Server
   |                                                |
   |                                                | clone/render Git repo
   |                                                v
   |                                           Rendered YAML
   |
   | compare desired vs live
   v
Kubernetes API Server
   |
   | apply resources
   v
Cluster Resources

argocd-server provides UI/API/CLI access for users to view and manage the process.
```

## What a Support Engineer Should Check

- Is the latest Git commit visible to Argo CD?
- Is the Application target revision correct?
- Is the repo-server able to clone and render the repo?
- Are Helm/Kustomize templates rendering successfully?
- Does the application-controller show reconciliation errors?
- Does the Kubernetes API server reject any resources because of RBAC, CRD, schema, or admission issues?
- Are workloads healthy after sync?
