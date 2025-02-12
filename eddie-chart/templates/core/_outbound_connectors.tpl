{{/*
Environment variable mappings for Admin Console Outbound Connector
*/}}
{{- define "eddie.outbound-connectors.admin-console.envs" }}
{{- $adminConsoleValues := .Values.outboundConnectors.adminConsole }}
{{- $ocPrefix := "OUTBOUND_CONNECTOR_ADMIN_CONSOLE" }}
- name: {{ $ocPrefix }}_ENABLED
  value: {{ $adminConsoleValues.enabled | quote }}
{{- if eq $adminConsoleValues.enabled "true" }}
- name: {{ $ocPrefix }}_LOGIN_ENABLED
  value: {{ $adminConsoleValues.login.enabled | quote }}
{{- end }}
{{- if eq $adminConsoleValues.login.enabled "true" }}
- name: {{ $ocPrefix }}_LOGIN_USERNAME
  value: {{ $adminConsoleValues.login.username | quote }}
- name: {{ $ocPrefix }}_LOGIN_ENCODEDPASSWORD
  value: {{ $adminConsoleValues.login.encodedPassword | quote }}
{{- end }}
{{- end }}
