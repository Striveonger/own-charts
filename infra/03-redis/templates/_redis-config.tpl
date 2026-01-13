{{/*
Redis configuration template
Generates redis.conf from structured values
*/}}
{{- define "redis.config" -}}
# Network
protected-mode {{ .Values.redis.config.protectedMode }}
port {{ .Values.redis.config.port }}
bind {{ .Values.redis.config.bind }}
tcp-backlog {{ .Values.redis.config.tcpBacklog }}
timeout {{ .Values.redis.config.timeout }}
tcp-keepalive {{ .Values.redis.config.tcpKeepalive }}

# General
daemonize no
pidfile {{ .Values.redis.config.pidfile }}
loglevel {{ .Values.redis.config.loglevel }}
logfile {{ .Values.redis.config.logfile | quote }}
databases {{ .Values.redis.config.databases }}
always-show-logo {{ .Values.redis.config.alwaysShowLogo }}
set-proc-title {{ .Values.redis.config.setProcTitle }}
proc-title-template {{ .Values.redis.config.procTitleTemplate | quote }}

# Security
{{- if .Values.redis.password }}
requirepass {{ .Values.redis.password }}
{{- end }}
acllog-max-len {{ .Values.redis.config.acllogMaxLen }}

# RDB Persistence
stop-writes-on-bgsave-error {{ .Values.redis.config.stopWritesOnBgsaveError }}
rdbcompression {{ .Values.redis.config.rdbcompression }}
rdbchecksum {{ .Values.redis.config.rdbchecksum }}
dbfilename {{ .Values.redis.config.dbfilename }}
rdb-del-sync-files {{ .Values.redis.config.rdbDelSyncFiles }}
dir {{ .Values.redis.dataDir }}
rdb-save-incremental-fsync {{ .Values.redis.config.rdbSaveIncrementalFsync }}

# Replication
replica-serve-stale-data {{ .Values.redis.config.replicaServeStaleData }}
replica-read-only {{ .Values.redis.config.replicaReadOnly }}
repl-diskless-sync {{ .Values.redis.config.replDisklessSync }}
repl-diskless-sync-delay {{ .Values.redis.config.replDisklessSyncDelay }}
repl-diskless-sync-max-replicas {{ .Values.redis.config.replDisklessSyncMaxReplicas }}
repl-diskless-load {{ .Values.redis.config.replDisklessLoad }}
repl-disable-tcp-nodelay {{ .Values.redis.config.replDisableTcpNodelay }}
replica-priority {{ .Values.redis.config.replicaPriority }}

# Lazy Freeing
lazyfree-lazy-eviction {{ .Values.redis.config.lazyfreeLazyEviction }}
lazyfree-lazy-expire {{ .Values.redis.config.lazyfreeLazyExpire }}
lazyfree-lazy-server-del {{ .Values.redis.config.lazyfreeLazyServerDel }}
replica-lazy-flush {{ .Values.redis.config.replicaLazyFlush }}
lazyfree-lazy-user-del {{ .Values.redis.config.lazyfreeLazyUserDel }}
lazyfree-lazy-user-flush {{ .Values.redis.config.lazyfreeLazyUserFlush }}

# OOM
oom-score-adj {{ .Values.redis.config.oomScoreAdj }}
oom-score-adj-values {{ .Values.redis.config.oomScoreAdjValues }}
disable-thp {{ .Values.redis.config.disableThp }}

# AOF Persistence
appendonly {{ .Values.redis.config.appendonly }}
appendfilename {{ .Values.redis.config.appendfilename | quote }}
appenddirname {{ .Values.redis.config.appenddirname | quote }}
appendfsync {{ .Values.redis.config.appendfsync }}
no-appendfsync-on-rewrite {{ .Values.redis.config.noAppendfsyncOnRewrite }}
auto-aof-rewrite-percentage {{ .Values.redis.config.autoAofRewritePercentage }}
auto-aof-rewrite-min-size {{ .Values.redis.config.autoAofRewriteMinSize }}
aof-load-truncated {{ .Values.redis.config.aofLoadTruncated }}
aof-use-rdb-preamble {{ .Values.redis.config.aofUseRdbPreamble }}
aof-timestamp-enabled {{ .Values.redis.config.aofTimestampEnabled }}
aof-rewrite-incremental-fsync {{ .Values.redis.config.aofRewriteIncrementalFsync }}

# Slow Log
slowlog-log-slower-than {{ .Values.redis.config.slowlogLogSlowerThan }}
slowlog-max-len {{ .Values.redis.config.slowlogMaxLen }}

# Latency Monitor
latency-monitor-threshold {{ .Values.redis.config.latencyMonitorThreshold }}

# Event Notification
notify-keyspace-events {{ .Values.redis.config.notifyKeyspaceEvents | quote }}

# Data Structure Optimization
hash-max-listpack-entries {{ .Values.redis.config.hashMaxListpackEntries }}
hash-max-listpack-value {{ .Values.redis.config.hashMaxListpackValue }}
list-max-listpack-size {{ .Values.redis.config.listMaxListpackSize }}
list-compress-depth {{ .Values.redis.config.listCompressDepth }}
set-max-intset-entries {{ .Values.redis.config.setMaxIntsetEntries }}
zset-max-listpack-entries {{ .Values.redis.config.zsetMaxListpackEntries }}
zset-max-listpack-value {{ .Values.redis.config.zsetMaxListpackValue }}
hll-sparse-max-bytes {{ .Values.redis.config.hllSparseMaxBytes }}
stream-node-max-bytes {{ .Values.redis.config.streamNodeMaxBytes }}
stream-node-max-entries {{ .Values.redis.config.streamNodeMaxEntries }}

# Advanced
activerehashing {{ .Values.redis.config.activerehashing }}
client-output-buffer-limit normal {{ .Values.redis.config.clientOutputBufferLimitNormal }}
client-output-buffer-limit replica {{ .Values.redis.config.clientOutputBufferLimitReplica }}
client-output-buffer-limit pubsub {{ .Values.redis.config.clientOutputBufferLimitPubsub }}
hz {{ .Values.redis.config.hz }}
dynamic-hz {{ .Values.redis.config.dynamicHz }}
jemalloc-bg-thread {{ .Values.redis.config.jemallocBgThread }}

# Extra custom configuration
{{- if .Values.redis.config.extra }}
{{ .Values.redis.config.extra }}
{{- end }}
{{- end -}}
