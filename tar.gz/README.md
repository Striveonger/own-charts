# 镜像备份目录

本目录用于备份 ARM64 架构的 Docker 镜像文件

## 保存镜像

```bash
docker save bitnami/redis:8.6.2 -o bitnami-redis-8.6.2.tar && gzip bitnami-redis-8.6.2.tar
```

## 恢复镜像

```bash
gunzip -c bitnami-redis-8.6.2.tar.gz | docker load
```

## 已备份镜像

| 镜像 | 版本 | 文件 |
|------|------|------|
| bitnami/redis | 8.6.2 | bitnami-redis-8.6.2.tar.gz |
