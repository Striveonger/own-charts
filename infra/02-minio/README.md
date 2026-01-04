# MinIO Helm Chart

This Helm chart deploys a MinIO Object Storage server in a Kubernetes cluster.

## Prerequisites

- Kubernetes 1.16+
- Helm 3.0+

## Installing the Chart

To install the chart with the release name `minio`:

```bash
helm upgrade --install minio . \
    --create-namespace --namespace infra \
    --values ../values/02-minio.yaml
```

## Configuration

The following table lists the configurable parameters of the MinIO chart and their default values.

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `image.repository` | MinIO image repository | `minio/minio` |
| `image.tag` | MinIO image tag | `RELEASE.2024-07-16T23-46-41Z` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `minio.rootUser` | MinIO root username | `root` |
| `minio.rootPassword` | MinIO root password | `A123456a` |
| `minio.dataDir` | MinIO data directory | `/data` |
| `minio.configDir` | MinIO config directory | `/root/.minio` |
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.apiPort` | MinIO API port | `9000` |
| `service.consolePort` | MinIO Console port | `9090` |
| `persistence.data.size` | Data PVC size | `20Gi` |
| `persistence.data.accessMode` | Data PVC access mode | `ReadWriteOnce` |
| `persistence.config.size` | Config PVC size | `1Gi` |
| `persistence.config.accessMode` | Config PVC access mode | `ReadWriteOnce` |
| `resources.limits.memory` | Memory limit | `1024Mi` |
| `resources.requests.memory` | Memory request | `512Mi` |

## Persistence

The chart creates two PersistentVolumeClaims for storing MinIO data and configuration:
- **Data PVC**: Default size is 20Gi with ReadWriteOnce access mode
- **Config PVC**: Default size is 1Gi with ReadWriteOnce access mode

## Accessing MinIO

### API Endpoint

The MinIO S3-compatible API is available at:
- Cluster internal: `minio.infra.svc.cluster.local:9000`
- External: Depending on service type (ClusterIP/NodePort/LoadBalancer)

### Console

The MinIO Web Console is available at:
- Cluster internal: `minio.infra.svc.cluster.local:9090`
- External: Depending on service type (ClusterIP/NodePort/LoadBalancer)

Default credentials:
- Username: `root`
- Password: `A123456a`

**Important**: Change the default credentials in production environments!

### From another application

To use MinIO S3 API from another application in the cluster:

```bash
# Endpoint
MINIO_ENDPOINT=minio.infra.svc.cluster.local:9000

# Credentials
MINIO_ACCESS_KEY=root
MINIO_SECRET_KEY=A123456a
```

## Service Discovery

MinIO services can be accessed from other namespaces using:
- API: `minio.infra.svc.cluster.local:9000`
- Console: `minio.infra.svc.cluster.local:9090`

## Upgrading

To upgrade the MinIO deployment:

```bash
helm upgrade minio . \
    --namespace infra \
    --values ../values/02-minio.yaml
```

## Uninstalling

To uninstall the MinIO deployment:

```bash
helm uninstall minio --namespace infra
```

**Note**: This will also delete the PersistentVolumeClaims and all data. Be sure to backup any important data before uninstalling.
