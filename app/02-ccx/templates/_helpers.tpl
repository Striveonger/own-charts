{{/*
Expand the name of the chart.
*/}}
{{- define "ccx.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "ccx.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart label.
*/}}
{{- define "ccx.label" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "\n" "" }}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "ccx.labels" -}}
app.kubernetes.io/name: {{ include "ccx.name" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/part-of: {{ .Chart.Name }}
helm.sh/chart: {{ include "ccx.label" . }}
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "ccx.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ccx.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
