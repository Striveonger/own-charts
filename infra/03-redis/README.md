# Redis Helm Chart

在 Kubernetes 集群中部署 Redis 缓存/数据库的 Helm Chart。

## 简介

Redis 是一个开源的内存数据结构存储，可用作数据库、缓存和消息代理。此 Chart 部署单节点 Redis 实例，适用于开发和测试环境。

## 安装

### 使用部署脚本

```bash
bash scripts/infra/03-redis.sh
```

### 使用 Helm

```bash
helm upgrade --install redis infra/03-redis \
    --create-namespace --namespace infra \
    --values infra/values/03-redis.yaml
```

## 配置

### 默认配置

| 参数 | 描述 | 默认值 |
|------|------|--------|
| `image.repository` | Redis 镜像仓库 | `docker.io/redis` |
| `image.tag` | Redis 镜像标签 | `7.4.2-alpine` |
| `image.pullPolicy` | 镜像拉取策略 | `IfNotPresent` |
| `replicaCount` | 副本数量 | `1` |
| `service.port` | Redis 服务端口 | `6379` |
| `service.type` | 服务类型 | `ClusterIP` |
| `redis.password` | Redis 密码（空表示无密码） | `""` |
| `redis.dataDir` | 数据目录 | `/data` |
| `persistence.enabled` | 启用持久化存储 | `true` |
| `persistence.size` | PVC 存储大小 | `2Gi` |
| `persistence.accessMode` | PVC 访问模式 | `ReadWriteOnce` |

### 资源配置

| 参数 | 描述 | 默认值 |
|------|------|--------|
| `resources.limits.cpu` | CPU 限制 | `500m` |
| `resources.limits.memory` | 内存限制 | `256Mi` |
| `resources.requests.cpu` | CPU 请求 | `250m` |
| `resources.requests.memory` | 内存请求 | `128Mi` |

## 使用说明

### 连接 Redis

从同一命名空间内的 Pod 连接：

```bash
redis-cli -h redis.infra.svc.cluster.local -p 6379
```

从其他命名空间的 Pod 连接：

```bash
redis-cli -h redis.infra.svc.cluster.local -p 6379
```

如果设置了密码：

```bash
redis-cli -h redis.infra.svc.cluster.local -p 6379 -a YOUR_PASSWORD
```

### 测试连接

```bash
# 使用 Helm test
helm test redis -n infra

# 手动测试
kubectl exec -it deployment/redis -n infra -- redis-cli ping
```

### 持久化数据

Redis 数据默认存储在持久卷中。如果删除 Pod，数据会在 Pod 重新创建后恢复。

## 服务发现

其他应用可以通过以下地址连接 Redis：

- **内部地址**: `redis.infra.svc.cluster.local:6379`
- **命名空间内部**: `redis:6379`（如果应用也在 `infra` 命名空间）

## 生产环境注意事项

1. **高可用性**: 此 Chart 部署单节点 Redis。生产环境应使用 Redis Sentinel 或 Redis Cluster
2. **密码**: 生产环境必须设置强密码，建议使用 Kubernetes Secrets
3. **持久化**: 确保 StorageClass 提供足够的性能和可靠性
4. **监控**: 添加 Redis 监控和告警

## 卸载

```bash
helm uninstall redis -n infra
```

## 维护

### 查看日志

```bash
kubectl logs -f deployment/redis -n infra
```

### 进入容器

```bash
kubectl exec -it deployment/redis -n infra -- sh
```

### 备份数据

```bash
# 创建快照
kubectl exec deployment/redis -n infra -- redis-cli SAVE

# 复制数据文件
kubectl cp infra/redis-0:/data/dump.rdb ./redis-backup.rdb
```
