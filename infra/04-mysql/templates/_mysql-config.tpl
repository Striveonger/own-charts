{{/*
MySQL configuration template
Generates my.cnf from structured values
*/}}
{{- define "mysql.config" -}}
[mysqld]
{{- range $key, $value := .Values.mysql.config }}
{{ $key }} = {{ $value | quote }}
{{- end }}
{{- end }}
