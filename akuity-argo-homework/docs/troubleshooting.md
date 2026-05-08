# Troubleshooting Notes

## Argo CD Application is OutOfSync

Check:

```bash
kubectl describe application <app-name> -n argocd
argocd app get <app-name>
argocd app diff <app-name>
```

Possible causes:

- Git contains a different desired state than the cluster.
- Manual change was made directly in the cluster.
- Auto-sync is disabled.
- A resource is blocked by RBAC or admission policy.

## Argo CD Application is Degraded

Check:

```bash
kubectl get pods -A
kubectl describe pod <pod-name> -n <namespace>
kubectl logs <pod-name> -n <namespace>
```

Possible causes:

- ImagePullBackOff
- CrashLoopBackOff
- Failed readiness/liveness probes
- Missing ConfigMap or Secret
- Invalid ServiceAccount or RBAC

## Repo Server Cannot Render Manifests

Check:

```bash
kubectl logs deployment/argocd-repo-server -n argocd
```

Possible causes:

- Invalid Helm chart
- Invalid Kustomize overlay
- Missing values file
- Git authentication issue
- Custom Helm binary not mounted correctly

## Prometheus Cannot Scrape Argo CD Metrics

Check:

```bash
kubectl get svc -n argocd
kubectl get servicemonitor -A
kubectl get prometheusrule -A
kubectl logs -n monitoring statefulset/prometheus-monitoring-kube-prometheus-prometheus
```

Possible causes:

- ServiceMonitor selector does not match Argo CD services.
- Prometheus Operator CRDs are missing.
- Wrong namespace selector.
- Metrics port name mismatch.

## Helm Version Replacement Check

Exec into repo-server and check Helm version:

```bash
kubectl exec -n argocd deployment/argocd-repo-server -- helm version
```

Expected result: Helm version should match the custom version configured in `custom-helm-version-patch.yaml`.
