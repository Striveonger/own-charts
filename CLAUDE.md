# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 仓库概述

这是一个用于在 Kubernetes 上部署容器化应用的 Helm Charts 仓库，分为两类：

- **infra/** - 基础设施组件（数据库、消息队列等）
- **apps/** - 应用组件

每个组件都有自己的 Helm Chart，对应的部署脚本位于 `scripts/` 目录。

## 目录结构

```
charts/
├── infra/                          # 基础设施 Charts
│   ├── 01-postgresql/             # PostgreSQL 数据库 Chart
│   ├── 02-minio/                  # MinIO 对象存储 Chart
│   ├── 03-redis/                  # Redis 缓存/数据库 Chart
│   ├── 04-mysql/                  # MySQL 数据库 Chart
│   └── 05-rocketmq/               # RocketMQ 消息队列 Chart
│   └── values/                    # 基础设施特定配置覆盖
│       ├── 01-postgres.yaml
│       ├── 02-minio.yaml
│       ├── 03-redis.yaml
│       ├── 04-mysql.yaml
│       └── 05-rocketmq.yaml
├── apps/                          # 应用 Charts（tgz 打包文件）
│   └── values/                    # 应用特定配置覆盖目录
└── scripts/                       # 部署脚本
    ├── infra/                     # 基础设施部署脚本
    │   ├── 00-env.sh              # 环境变量配置
    │   ├── 01-postgresql.sh
    │   ├── 02-minio.sh
    │   ├── 03-redis.sh
    │   ├── 04-mysql.sh
    │   └── 05-rocketmq.sh
    └── apps/                      # 应用部署脚本（需先打包 Chart）
```

## 部署命令

### 部署基础设施

#### PostgreSQL

```bash
bash scripts/infra/01-postgresql.sh
```

或直接使用 Helm：

```bash
helm upgrade --install postgresql infra/01-postgresql \
    --create-namespace --namespace infra \
    --values infra/values/01-postgres.yaml
```

#### MinIO

```bash
bash scripts/infra/02-minio.sh
```

或直接使用 Helm：

```bash
helm upgrade --install minio infra/02-minio \
    --create-namespace --namespace infra \
    --values infra/values/02-minio.yaml
```

#### Redis

```bash
bash scripts/infra/03-redis.sh
```

或直接使用 Helm：

```bash
helm upgrade --install redis infra/03-redis \
    --create-namespace --namespace infra \
    --values infra/values/03-redis.yaml
```

#### MySQL

```bash
bash scripts/infra/04-mysql.sh
```

或直接使用 Helm：

```bash
helm upgrade --install mysql infra/04-mysql \
    --create-namespace --namespace infra \
    --values infra/values/04-mysql.yaml
```

#### RocketMQ

```bash
bash scripts/infra/05-rocketmq.sh
```

或直接使用 Helm：

```bash
helm upgrade --install rocketmq infra/05-rocketmq \
    --create-namespace --namespace infra \
    --values infra/values/05-rocketmq.yaml
```

### 部署应用

应用部署需要先将 Chart 打包为 tgz 文件，再进行部署：

```bash
# 打包应用 Chart（如 dispatch-notice）
helm package apps/dispatch-notice

# 部署应用
helm upgrade --install dispatch-notice apps/dispatch-notice-1.0.0.tgz \
    --create-namespace --namespace apps \
    --values apps/values/dispatch-notice.yaml
```

### 检查部署状态

```bash
# 检查基础设施部署
helm status postgresql -n infra
helm status minio -n infra
helm status redis -n infra
helm status mysql -n infra
helm status rocketmq -n infra
kubectl get pods -n infra

# 检查应用部署（如已部署）
helm status <app-name> -n apps
kubectl get pods -n apps
```

### 卸载部署

```bash
# 卸载基础设施
helm uninstall postgresql -n infra
helm uninstall minio -n infra
helm uninstall redis -n infra
helm uninstall mysql -n infra
helm uninstall rocketmq -n infra

# 卸载应用（如已部署）
helm uninstall <app-name> -n apps
```

## Chart 架构

### 命名约定

- 基础设施 Chart 使用数字前缀（如 `01-postgresql`）表示部署顺序
- 命名空间：`infra` 用于基础设施，`apps` 用于应用
- 服务发现格式：`{service-name}.{namespace}.svc.cluster.local`

### 配置分层

Chart 采用两层配置方式：

1. **默认值**（Chart 目录下的 `values.yaml`）- 基础配置
2. **环境覆盖**（`values/*.yaml`）- 环境特定设置

部署时使用 `--values` 应用环境特定覆盖。

### 服务发现

跨命名空间通信遵循以下模式：
- 从应用访问 PostgreSQL：`postgresql.infra.svc.cluster.local:5432`
- 从应用访问 MinIO API：`minio.infra.svc.cluster.local:9000`
- 从应用访问 MinIO Console：`minio.infra.svc.cluster.local:9090`
- 从应用访问 Redis：`redis.infra.svc.cluster.local:6379`
- 从应用访问 MySQL：`mysql.infra.svc.cluster.local:3306`
- 从应用访问 RocketMQ NameServer：`rocketmq-ns.infra.svc.cluster.local:9876`
- 从应用访问 RocketMQ Broker：`rocketmq-broker.infra.svc.cluster.local:10911`
- 从应用访问 RocketMQ Proxy：`rocketmq-proxy.infra.svc.cluster.local:8080`
- 从应用访问 RocketMQ Dashboard：`rocketmq-dashboard.infra.svc.cluster.local:8082`
- 命名空间内部服务：`{service-name}.{namespace}.svc.cluster.local`

### 模板约定

- PostgreSQL 使用 `_helpers.tpl` 定义标签和命名模板
- Redis 使用 `_redis-config.tpl` 生成 redis.conf 配置文件
- MySQL 使用 `_mysql-config.tpl` 生成 my.cnf 配置文件
- 应用使用 `_volume.tpl` 和 `_probe.tpl` 复用卷和探针模板

## 当前 Charts

### PostgreSQL (infra/01-postgresql)

- **镜像**：`postgres:18-trixie`
- **端口**：5432
- **数据目录**：`/var/lib/postgresql/18/docker`
- **存储**：10Gi PVC
- **命名空间**：`infra`

### MinIO (infra/02-minio)

- **镜像**：`minio/minio:RELEASE.2024-07-16T23-46-41Z`
- **端口**：API 9000，Console 9090
- **数据目录**：`/data`
- **配置目录**：`/root/.minio`
- **存储**：数据 20Gi PVC，配置 1Gi PVC
- **命名空间**：`infra`
- **默认凭据**：root / A123456a

### Redis (infra/03-redis)

- **镜像**：`redis:7.0.11`
- **端口**：6379
- **数据目录**：`/data`
- **存储**：2Gi PVC
- **命名空间**：`infra`
- **默认密码**：A123456a
- **配置**：使用 `_redis-config.tpl` 生成 redis.conf，支持通过 `values.yaml` 灵活配置

### MySQL (infra/04-mysql)

- **镜像**：`mysql:8.0`
- **端口**：3306
- **数据目录**：`/var/lib/mysql`
- **存储**：10Gi PVC
- **命名空间**：`infra`
- **默认密码**：A123456a (root)

### RocketMQ (infra/05-rocketmq)

- **Chart 版本**：12.6.0 (appVersion: 5.3.2)
- **镜像**：`apache/rocketmq:5.3.2`
- **NameServer 端口**：9876
- **Broker 端口**：10911
- **Proxy 端口**：8080 (启用)
- **Dashboard 端口**：8082 (启用)
- **存储**：Broker 20Gi PVC，Controller 20Gi PVC
- **命名空间**：`infra`
- **组件**：
  - NameServer (1 副本)
  - Broker (1 主 0 从，SYNC_MASTER)
  - Proxy (1 副本)
  - Dashboard (1 副本，管理界面)
  - Controller (1 副本，集群模式)
- **默认凭据**：Dashboard admin/admin

### Dispatch Notice (apps/)

预留的应用部署位置，当前 `apps/` 目录仅包含 `values/` 子目录用于存放应用配置覆盖文件。

## 常见模式

### Helm Chart 验证

```bash
# 验证 Chart 语法和配置
helm lint infra/01-postgresql

# 模板渲染测试（不实际部署）
helm template test-release infra/01-postgresql --values infra/values/01-postgres.yaml

# 调试模式（显示生成的 manifest）
helm template test-release infra/01-postgresql --debug --values infra/values/01-postgres.yaml
```

### 幂等部署

所有部署脚本使用 `helm upgrade --install` 实现幂等操作，可以安全地多次运行同一脚本。

### 资源管理

资源限制和请求在默认值文件和覆盖文件中都有定义。覆盖文件（`values/*.yaml`）优先级更高。

### 健康检查

- PostgreSQL：使用 `pg_isready -U postgres` 进行存活性和就绪性探针
- MinIO：使用 HTTP 端点 `/minio/health/live` 和 `/minio/health/ready`
- Redis：使用 `redis-cli ping` 进行存活性和就绪性探针
- MySQL：使用 `mysqladmin ping` 进行存活性和就绪性探针
- RocketMQ：使用 `netstat` 检查端口监听状态 (NameServer/9876, Broker/10911, Proxy/8080)
- Dashboard：使用 HTTP 端点 `/` 进行健康检查
- Spring Boot 应用：使用 Actuator 端点（`/actuator/health/liveness`、`/actuator/health/readiness`）

### 连接配置

应用连接基础设施组件时，使用全限定域名：

#### PostgreSQL
```yaml
# 在应用的 values 中配置数据库连接
host: postgresql.infra.svc.cluster.local
port: 5432
user: postgres
password: A123456a
```

#### MinIO
```yaml
# 在应用的 values 中配置 MinIO 连接
endpoint: minio.infra.svc.cluster.local:9000
accessKey: root
secretKey: A123456a
```

#### Redis
```yaml
# 在应用的 values 中配置 Redis 连接
host: redis.infra.svc.cluster.local
port: 6379
password: A123456a
```

#### MySQL
```yaml
# 在应用的 values 中配置数据库连接
host: mysql.infra.svc.cluster.local
port: 3306
user: root
password: A123456a
database: app_db
```

#### RocketMQ
```yaml
# 在应用的 values 中配置 RocketMQ 连接
nameserver: rocketmq-ns.infra.svc.cluster.local:9876
broker: rocketmq-broker.infra.svc.cluster.local:10911
proxy: rocketmq-proxy.infra.svc.cluster.local:8080

# Dashboard 访问 (集群IP)
dashboard: rocketmq-dashboard.infra.svc.cluster.local:8082
```

## 开发工作流

1. 修改 `infra/values/*.yaml` 或 `apps/values/*.yaml` 中的 Chart 值
2. 运行对应的部署脚本
3. 使用 `helm status` 或 `kubectl get pods` 验证部署

## 注意事项

- PostgreSQL 默认密码在 `infra/values/01-postgres.yaml` 中设置（生产环境应使用 Secrets）
- MinIO 默认密码在 `infra/values/02-minio.yaml` 中设置（生产环境应使用 Secrets）
- Redis 默认密码在 `infra/values/03-redis.yaml` 中设置（生产环境应使用 Secrets）
- MySQL 默认密码在 `infra/values/04-mysql.yaml` 中设置（生产环境应使用 Secrets）
- RocketMQ Dashboard 访问地址：`http://rocketmq-dashboard.infra.svc.cluster.local:8082`
- 默认管理员账号：admin / admin
- 默认普通用户账号：user01 / userPass
- 应用日志使用 hostPath 挂载（生产环境建议使用日志解决方案）
- Chart 独立版本管理 - 查看 `Chart.yaml` 获取版本信息
- 部署顺序：先部署基础设施（如 PostgreSQL、MinIO、Redis、MySQL、RocketMQ），再部署依赖它的应用
