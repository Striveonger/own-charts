# 镜像备份

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


# 自有镜像

本目录用于备份自定义的 Docker 镜像文件

```bash
# 1. 创建并启用 多平台构建器
docker buildx create --name multi-platform-builder \
  --platform linux/amd64,linux/arm64 \
  --driver docker-container \
  --driver-opt network=host \
  --driver-opt env.HTTP_PROXY="http://127.0.0.1:7890" \
  --driver-opt env.HTTPS_PROXY="http://127.0.0.1:7890" \
  --use
# 2. 启动当前的构建器
docker buildx inspect --bootstrap
# 3. 为防止连接超时, 提前准备好"梯子"
export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
# 4. 开始多平台构建, 并推送到 Docker-Hub (分别到 ubuntu 和 python 目录下进行构建)
docker buildx build --platform linux/amd64,linux/arm64 -t striveonger/ubuntu:22.04 --push .
docker buildx build --platform linux/amd64,linux/arm64 -t striveonger/python:3.12 --push .
# 5. 关掉代理配置
unset all_proxy
unset http_proxy
unset https_proxy
```
