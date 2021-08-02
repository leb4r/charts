{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "cardano.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cardano.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cardano.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "cardano.labels" -}}
helm.sh/chart: {{ include "cardano.chart" . }}
{{ include "cardano.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "cardano.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cardano.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "cardano.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "cardano.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the cardano topology JSON config files
*/}}
{{- define "cardano.topologyJson" -}}
{{ $defaultProducers := list (dict "addr" (printf "relays-new.cardano-%s.iohk.io" .Values.cardano.network) "port" 3001 "valency" 1) }}
{{ $producers := list }}
{{- if .Values.cardano.producers -}}
{{ $producers := concat $defaultProducers .Values.cardano.producers }}
{{- else -}}
{{ $producers := $defaultProducers }}
{{- end -}}
{{ toPrettyJson (dict "Producers" $producers) }}
{{- end -}}
