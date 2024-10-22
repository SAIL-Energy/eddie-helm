{{/*
Metadata for core components
*/}}
{{- define "eddie.core.labels" }}
labels:
  app: {{ .Release.Name }}-core
{{- include "eddie.labels" . }}
{{- end }}
{{/*

{{/*
Metadata for emqx components
*/}}
{{- define "eddie.emqx.labels" }}
labels:
  app: {{ .Release.Name }}-emqx
{{- include "eddie.labels" . }}
{{- end }}
{{/*

Metadata for kafka components
*/}}
{{- define "eddie.kafka.labels" }}
labels:
  app: {{ .Release.Name }}-kafka
{{- include "eddie.labels" . }}
{{- end }}

{{/*
Metadata for postgres components
*/}}
{{- define "eddie.postgres.labels" }}
labels:
  app: {{ .Release.Name }}-postgres
{{- include "eddie.labels" . }}
{{- end }}

{{/*
Metadata for eddie components
*/}}
{{- define "eddie.labels" }}
  generator: helm
  date: {{ now | htmlDate }}
  chart: {{ .Chart.Name }}
  version: {{ .Chart.Version }}
{{- end }}

{{/*
Helper to build the postgres Url
*/}}
{{- define "eddie.postgres-url" -}}
"jdbc:postgresql://{{ .Release.Name }}-postgres:{{ .Values.postgres.port }}/{{ .Values.postgres.database }}"
{{- end }}

{{/*
Helper to build kafka
*/}}
{{- define "eddie.kafka-url" -}}
"{{ .Release.Name }}-kafka:9094"
{{- end }}
