# PostgreSQL Helm Chart

This Helm chart deploys a PostgreSQL database in a Kubernetes cluster.

## Prerequisites

- Kubernetes 1.16+
- Helm 3.0+

## Installing the Chart

To install the chart with the release name `postgresql`:

```bash
helm upgrade --install postgresql . \
    --create-namespace --namespace infra \
    --values ../values/postgres.yaml
```

## Configuration

The following table lists the configurable parameters of the PostgreSQL chart and their default values.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `image.repository` | PostgreSQL image repository | `postgres` |
| `image.tag` | PostgreSQL image tag | `15.3` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `postgresql.postgresPassword` | PostgreSQL password | `123456` |
| `postgresql.pgData` | PostgreSQL data directory | `/var/lib/postgresql/data/pgdata` |
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.port` | PostgreSQL service port | `5432` |
| `resources.limits.cpu` | CPU limit | `1000m` |
| `resources.limits.memory` | Memory limit | `1024Mi` |
| `resources.requests.cpu` | CPU request | `500m` |
| `resources.requests.memory` | Memory request | `512Mi` |

## Persistence

The chart creates a PersistentVolumeClaim for storing PostgreSQL data. The default size is 10Gi with ReadWriteOnce access mode.

## Connecting to PostgreSQL

To connect to your PostgreSQL database:

1. Get the PostgreSQL pod name:
   ```bash
   kubectl get pods -n infra
   ```

2. Connect to the database:
   ```bash
   kubectl exec -it <postgresql-pod-name> -n infra -- psql -U postgres
   ```

Or connect from another pod in the same cluster using the service name `postgresql` on port 5432.