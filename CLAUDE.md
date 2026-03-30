# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 仓库概述

这是一个用于在 Kubernetes 上部署容器化应用的 Helm Charts 仓库，分为两类：

- **infra/** - 基础设施组件（数据库、消息队列等）
- **app/** - 应用组件

## 目录结构

```
.
├── infra/                         # 基础设施 Charts
│   ├── 01-postgresql/             # PostgreSQL
│   ├── 02-minio/                  # MinIO 对象存储
│   ├── 03-redis/                  # Redis 缓存
│   ├── 04-mysql/                  # MySQL
│   ├── 05-rocketmq/               # RocketMQ 消息队列
│   └── values/                    # 基础设施配置覆盖
│       ├── 01-postgres.yaml
│       ├── 02-minio.yaml
│       ├── 03-redis.yaml
│       ├── 04-mysql.yaml
│       └── 05-rocketmq.yaml
├── app/                            # 应用 Charts
│   ├── 01-jenkins/                 # Jenkins
│   └── values/                     # 应用配置覆盖
└── scripts/                        # 部署脚本
    ├── infra/                      # 基础设施部署脚本
    └── app/                        # 应用部署脚本
```

## 部署命令

### 基础设施部署

使用 `helm upgrade --install` 配合对应脚本实现幂等部署：

```bash
bash scripts/infra/01-postgresql.sh   # PostgreSQL
bash scripts/infra/02-minio.sh        # MinIO
bash scripts/infra/03-redis.sh        # Redis
bash scripts/infra/04-mysql.sh        # MySQL
bash scripts/infra/05-rocketmq.sh     # RocketMQ
```

### 应用部署

```bash
bash scripts/app/01-jenkins.sh
```

### 本地调试

```bash
# 验证 Chart 语法
helm lint <chart>

# 本地渲染模板（不实际部署）
helm template test-release <chart> --values <values-file>

# 调试模式（显示生成的 manifest）
helm template test-release <chart> --debug --values <values-file>
```

## 配置分层

Chart 采用两层配置方式：

1. **默认值**（Chart 目录下的 `values.yaml`）- 基础配置
2. **环境覆盖**（`infra/values/*.yaml` 或 `app/values/*.yaml`）- 环境特定设置

部署时使用 `--values` 应用环境特定覆盖。

## 服务发现

跨命名空间通信使用全限定域名格式：

| 组件 | 地址 |
|------|------|
| PostgreSQL | `postgresql.infra.svc.cluster.local:5432` |
| MinIO API | `minio.infra.svc.cluster.local:9000` |
| MinIO Console | `minio.infra.svc.cluster.local:9090` |
| Redis | `redis.infra.svc.cluster.local:6379` |
| MySQL | `mysql.infra.svc.cluster.local:3306` |
| RocketMQ NameServer | `rocketmq-ns.infra.svc.cluster.local:9876` |
| RocketMQ Broker | `rocketmq-broker.infra.svc.cluster.local:10911` |
| RocketMQ Proxy | `rocketmq-proxy.infra.svc.cluster.local:8080` |
| RocketMQ Dashboard | `rocketmq-dashboard.infra.svc.cluster.local:8082` |

## 健康检查

各组件使用不同的探针方式：

- **PostgreSQL**: `pg_isready -U postgres`
- **MinIO**: HTTP 端点 `/minio/health/live` 和 `/minio/health/ready`
- **Redis**: `redis-cli ping`
- **MySQL**: `mysqladmin ping`
- **RocketMQ**: `netstat` 检查端口监听状态
- **Jenkins**: HTTP 端点 `/login` (带 2xx 响应)

## 模板约定

部分 Chart 使用自定义配置模板生成配置文件：

- **Redis**: `_redis-config.tpl` 定义 `redis.config` 模板，生成 `redis.conf`
- **MySQL**: `_mysql-config.tpl` 定义 `mysql.config` 模板，生成 `my.cnf`

所有 Chart 使用 `_helpers.tpl` 定义通用标签和命名模板。

## 常用开发命令

```bash
# 检查部署状态
helm status <release> -n <namespace>
kubectl get pods -n <namespace>

# 卸载
helm uninstall <release> -n <namespace>

# 打包应用 Chart（如需要分发给其他环境）
helm package apps/<chart-name>
```

## 默认凭据（测试环境）

- **PostgreSQL/MySQL/Redis/MinIO**: `root` / `A123456a`
- **RocketMQ Dashboard**: `admin` / `A123456a`
- **Jenkins**: `admin` / `A123456a`

生产环境应使用 Kubernetes Secrets 管理这些凭据。
