# Stack Patterns: Kubernetes + Helm + Skaffold

Decomposition patterns for infrastructure-as-code projects using Kubernetes manifests, Helm charts, and Skaffold for local development.

## Typical Layer Mapping

| Layer | K8s Equivalent | Common Paths |
|-------|---------------|--------------|
| Config | ConfigMaps, Secrets, env values | `helm/values.yaml`, `k8s/configmaps/` |
| Schema/Data | PVCs, StatefulSets (databases) | `helm/templates/statefulset.yaml`, `k8s/storage/` |
| Data Access | Services (ClusterIP), ServiceAccounts | `helm/templates/service.yaml` |
| Service | Deployments, Jobs, CronJobs | `helm/templates/deployment.yaml` |
| API/Interface | Ingress, Gateway, NetworkPolicy | `helm/templates/ingress.yaml` |
| Integration | Skaffold config, Kustomize overlays | `skaffold.yaml`, `kustomize/overlays/` |
| Testing | Helm tests, connectivity checks | `helm/templates/tests/` |

## Decomposition Order

### 1. Namespace and RBAC first
Everything else lives inside the namespace and needs permissions.

```markdown
## 1. Namespace & RBAC
- [ ] 1.1 Create namespace manifest or Helm namespace config
- [ ] 1.2 Create ServiceAccount and RBAC roles
```

### 2. Config and secrets before workloads
ConfigMaps and Secrets must exist before Deployments reference them.

```markdown
## 2. Configuration
- [ ] 2.1 Create ConfigMap with application settings
- [ ] 2.2 Create Secret manifest (or ExternalSecret) for credentials
- [ ] 2.3 Add values.yaml entries for configurable parameters
```

### 3. Storage before stateful workloads
PersistentVolumeClaims must exist before StatefulSets that mount them.

```markdown
## 3. Storage
- [ ] 3.1 Create PVC for database storage
- [ ] 3.2 Create StatefulSet for PostgreSQL
```

### 4. Deployments after their dependencies
Each Deployment is a separate task. Order by dependency chain.

```markdown
## 4. Workloads
- [ ] 4.1 Create backend Deployment
- [ ] 4.2 Create frontend Deployment
- [ ] 4.3 Create worker CronJob for batch processing
```

### 5. Services and networking
ClusterIP Services expose Deployments internally. Ingress exposes externally.

```markdown
## 5. Networking
- [ ] 5.1 Create ClusterIP Services for backend and frontend
- [ ] 5.2 Create Ingress with TLS configuration
- [ ] 5.3 Create NetworkPolicy restricting pod-to-pod traffic
```

### 6. Skaffold and local dev
Skaffold config ties everything together for local development.

```markdown
## 6. Local Development
- [ ] 6.1 Create or update skaffold.yaml with new manifests
- [ ] 6.2 Add port-forward configuration for local access
```

### 7. Helm tests
Helm test pods verify the deployment works.

```markdown
## 7. Validation
- [ ] 7.1 Create Helm test pod for backend health check
- [ ] 7.2 Create Helm test pod for database connectivity
```

## Common Pitfalls

- **Don't combine Deployment + Service in one task** — they're separate resources with separate concerns
- **Don't create Ingress before Services** — Ingress routes to Services; the Service must exist first
- **Don't modify values.yaml in every task** — consolidate values.yaml changes into the Configuration section, then reference them in later templates
- **Separate Helm chart structure (Chart.yaml, helpers) from templates** — chart scaffolding is a distinct task from writing templates
