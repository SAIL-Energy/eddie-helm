{{/*
Environment variable mappings for AT EDA region connector
*/}}
{{- define "eddie.region-connectors.at-eda.envs" }}
{{- $edaValues := .Values.regionConnectors.atEda }}
{{- $pontonValues := .Values.regionConnectors.atEda.pontonMessenger }}
{{- $rcPrefix := "REGION_CONNECTOR_AT_EDA" }}
{{- $pontonPrefix := "REGION_CONNECTOR_AT_EDA_PONTON_MESSENGER" }}
{{- if eq $edaValues.enabled "true" }}
- name: {{ $rcPrefix }}_ENABLED
  value: {{ $edaValues.enabled | quote }}
- name: {{ $rcPrefix }}_ELIGIBLEPARTY_ID
  value: {{ $edaValues.eligiblePartyId | quote }}
- name: {{ $pontonPrefix }}_ADAPTER_ID
  value: {{ $pontonValues.adapter.id | quote }}
- name: {{ $pontonPrefix }}_ADAPTER_VERSION
  value: {{ $pontonValues.adapter.version | quote }}
- name: {{ $pontonPrefix }}_HOSTNAME
  value: {{ $pontonValues.hostname | quote }}
- name: {{ $pontonPrefix }}_API_ENDPOINT
  value: {{ $pontonValues.apiEndpoint | quote }}
- name: {{ $pontonPrefix }}_PORT
  value: {{ $pontonValues.port | quote }}
- name: {{ $pontonPrefix }}_FOLDER
  value: {{ $pontonValues.folder | quote }}
- name: {{ $pontonPrefix }}_USERNAME
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-region-connector-secrets
      key: pontonUsername
- name: {{ $pontonPrefix }}_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-region-connector-secrets
      key: pontonPassword
{{- end }}
{{- end }}

{{/*
Environment variable mappings for FR ENEDIS region connector
*/}}
{{- define "eddie.region-connectors.fr-enedis.envs" }}
{{- $enedisValues := .Values.regionConnectors.frEnedis }}
{{- $rcPrefix := "REGION_CONNECTOR_FR_ENEDIS" }}
{{- if eq $enedisValues.enabled "true" }}
- name: {{ $rcPrefix }}_ENABLED
  value: {{ $enedisValues.enabled | quote }}
- name: {{ $rcPrefix }}_BASEPATH
  value: {{ $enedisValues.basePath | quote }}
- name: {{ $rcPrefix }}_CLIENT_ID
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-region-connector-secrets
      key: enedisClientId
- name: {{ $rcPrefix }}_CLIENT_SECRET
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-region-connector-secrets
      key: enedisClientSecret
- name: {{ $rcPrefix }}_POLLING
  value: {{ $enedisValues.polling | quote }}
{{- end }}
{{- end }}

{{/*
Environment variable mappings for DK ENERGINET region connector
*/}}
{{- define "eddie.region-connectors.dk-energinet.envs" }}
{{- $rcPrefix := "REGION_CONNECTOR_DK_ENERGINET" }}
{{- $energinetValues := .Values.regionConnectors.dkEnerginet }}
{{- if eq $energinetValues.enabled "true" }}
- name: {{ $rcPrefix }}_ENABLED
  value: {{ $energinetValues.enabled | quote }}
- name: {{ $rcPrefix }}_CUSTOMER_CLIENT_BASEPATH
  value: {{ $energinetValues.customer.client.basePath | quote }}
- name: {{ $rcPrefix }}_CUSTOMER_CLIENT_ID
  value: {{ $energinetValues.customer.client.id | quote }}
- name: {{ $rcPrefix }}_POLLING
  value: {{ $energinetValues.polling | quote }}
- name: {{ $rcPrefix }}_RETRY
  value: {{ $energinetValues.retry | quote }}
{{- end }}
{{- end }}

{{/*
Environment variable mappings for ES Datadis region connector
*/}}
{{- define "eddie.region-connectors.es-datadis.envs" }}
{{- $datadisValues := .Values.regionConnectors.esDatadis }}
{{- $rcPrefix := "REGION_CONNECTOR_ES_DATADIS" }}
{{- if eq $datadisValues.enabled "true" }}
- name: {{ $rcPrefix }}_ENABLED
  value: {{ $datadisValues.enabled | quote }}
- name: {{ $rcPrefix }}_USERNAME
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-region-connector-secrets
      key: datadisUsername
- name: {{ $rcPrefix }}_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-region-connector-secrets
      key: datadisPassword
- name: {{ $rcPrefix }}_POLLING
  value: {{ $datadisValues.polling | quote }}
- name: {{ $rcPrefix }}_RETRY
  value: {{ $datadisValues.retry | quote }}
- name: {{ $rcPrefix }}_BASEPATH
  value: {{ $datadisValues.basePath | quote }}
{{- end }}
{{- end }}

{{/*
Environment variable mappings for US Green Button region connector
*/}}
{{- define "eddie.region-connectors.us-green-button.envs" }}
{{- $greenButtonValues := .Values.regionConnectors.usGreenButton }}
{{- $rcPrefix := "REGIONCONNECTOR_US_GREEN_BUTTON" }}
{{- if eq $greenButtonValues.enabled "true" }}
- name: {{ $rcPrefix }}_ENABLED
  value: {{ $greenButtonValues.enabled | quote }}
- name: {{ $rcPrefix }}_BASEPATH
  value: {{ $greenButtonValues.basePath | quote }}
- name: {{ $rcPrefix }}_REDIRECTURI
  value: {{ $greenButtonValues.redirectUrl | quote }}
- name: {{ $rcPrefix }}_APITOKEN
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-region-connector-secrets
      key: greenButtonClientApiToken
- name: {{ $rcPrefix }}_WEBHOOK_SECRET
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-region-connector-secrets
      key: greenButtonWebhookSecret
- name: {{ $rcPrefix }}_ACTIVATIONBATCHSIZE
  value: {{ $greenButtonValues.activationBatchSize | quote }}
{{- range $greenButtonValues.clients }}
- name: {{ $rcPrefix }}_CLIENTIDS_{{ .name }}
  valueFrom:
    secretKeyRef:
      name: {{ $.Release.Name }}-region-connector-secrets
      key: greenButton{{ .name }}Id
- name: {{ $rcPrefix }}_CLIENTSECRETS_{{ .name }}
  valueFrom:
    secretKeyRef:
      name: {{ $.Release.Name }}-region-connector-secrets
      key: greenButton{{ .name }}ClientSecret
{{- end }}
{{- end }}
{{- end }}


{{/*
Volume mount for fingrid keystore
*/}}
{{- define "eddie.region-connectors.fi-fingrid.volumeMount"}}
{{- $fingridValues := .Values.regionConnectors.fiFingrid }}
{{- if eq $fingridValues.enabled "true" }}
- name: fingrid-keystore
  mountPath: /opt/fingrid-keystore
{{- end }}
{{- end }}

{{/*
Volume for fingrid keystore
*/}}
{{- define "eddie.region-connectors.fi-fingrid.volume"}}
{{- $fingridValues := .Values.regionConnectors.fiFingrid }}
{{- if eq $fingridValues.enabled "true" }}
- name: fingrid-keystore
  secret:
    secretName: {{ $fingridValues.keystore.secretName }}
{{- end }}
{{- end }}

{{/*
Environment variable mappings for FI Fingrid region connector
*/}}
{{- define "eddie.region-connectors.fi-fingrid.envs" }}
{{- $fingridValues := .Values.regionConnectors.fiFingrid }}
{{- $rcPrefix := "REGION_CONNECTOR_FI_FINGRID" }}
{{- $keystorePrefix := "SPRING_SSL_BUNDLE_JKS_FINGRID" }}
{{- if eq $fingridValues.enabled "true" }}
- name: {{ $rcPrefix }}_ENABLED
  value: {{ $fingridValues.enabled | quote }}
- name: {{ $rcPrefix }}_API_URL
  value: {{ $fingridValues.apiUrl | quote }}
- name: {{ $rcPrefix }}_ORGANISATION_USER
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-region-connector-secrets
      key: fingridOrganisationUser
- name: {{ $rcPrefix }}_ORGANISATION_NAME
  value: {{ $fingridValues.organisation.name | quote }}
- name: {{ $keystorePrefix }}_KEYSTORE_LOCATION
  value: "/opt/fingrid-keystore/fingrid.jks"
- name: {{ $keystorePrefix }}_KEYSTORE_TYPE
  value: "JKS"
- name: {{ $keystorePrefix }}_KEYSTORE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-region-connector-secrets
      key: fingridKeystorePassword
- name: {{ $keystorePrefix }}_KEY_ALIAS
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-region-connector-secrets
      key: fingridKeyAlias
- name: {{ $keystorePrefix }}_KEY_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-region-connector-secrets
      key: fingridKeyPassword
{{- end }}
{{- end }}

{{/*
Volume mount for NL Mijn Aansluiting keystore
*/}}
{{- define "eddie.region-connectors.nl-mijn-aansluiting.volumeMount"}}
{{- $aansluitingValues := .Values.regionConnectors.nlMijnAansluiting }}
{{- if eq $aansluitingValues.enabled "true" }}
- name: aansluiting-keystore
  mountPath: /opt/aansluiting-keystore
{{- end }}
{{- end }}

{{/*
Volume for NL Mijn Aansluiting keystore
*/}}
{{- define "eddie.region-connectors.nl-mijn-aansluiting.volume"}}
{{- $aansluitingValues := .Values.regionConnectors.nlMijnAansluiting }}
{{- if eq $aansluitingValues.enabled "true" }}
- name: aansluiting-keystore
  secret:
    secretName: {{ $aansluitingValues.keystore.secretName }}
{{- end }}
{{- end }}

{{/*
Environment variable mappings for NL Mijn Aansluiting region connector
*/}}
{{- define "eddie.region-connectors.nl-mijn-aansluiting.envs" }}
{{- $aansluitingValues := .Values.regionConnectors.nlMijnAansluiting }}
{{- $rcPrefix := "REGION_CONNECTOR_NL_MIJN_AANSLUITING" }}
{{- $keystorePrefix := "SPRING_SSL_BUNDLE_JKS_NL" }}
{{- if eq $aansluitingValues.enabled "true" }}
- name: {{ $rcPrefix }}_ENABLED
  value: {{ $aansluitingValues.enabled | quote }}
- name: {{ $rcPrefix }}_ISSUER_URL
  value: {{ $aansluitingValues.issuerUrl | quote }}
- name: {{ $rcPrefix }}_REDIRECT_URL
  value: {{ $aansluitingValues.redirectUrl | quote }}
- name: {{ $rcPrefix }}_SINGLE_KEY_ID
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-region-connector-secrets
      key: mijnAansluitingSingleKeyId
- name: {{ $rcPrefix }}_SINGLE_CLIENT_ID
  value: {{ $aansluitingValues.single.clientId | quote }}
- name: {{ $rcPrefix }}_SINGLE_SCOPE
  value: {{ $aansluitingValues.single.scope | quote }}
- name: {{ $rcPrefix }}_CONTINUOUS_KEY_ID
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-region-connector-secrets
      key: mijnAansluitingContinuousKeyId
- name: {{ $rcPrefix }}_CONTINUOUS_CLIENT_ID
  value: {{ $aansluitingValues.continuous.clientId | quote }}
- name: {{ $rcPrefix }}_CONTINUOUS_SCOPE
  value: {{ $aansluitingValues.continuous.scope | quote }}
- name: {{ $keystorePrefix }}_KEYSTORE_LOCATION
  value: "/opt/aansluiting-keystore/aansluiting.jks"
- name: {{ $keystorePrefix }}_KEYSTORE_TYPE
  value: "JKS"
- name: {{ $keystorePrefix }}_KEYSTORE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-region-connector-secrets
      key: mijnAansluitingKeystorePassword
- name: {{ $keystorePrefix }}_KEY_ALIAS
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-region-connector-secrets
      key: mijnAansluitingKeyAlias
- name: {{ $keystorePrefix }}_KEY_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-region-connector-secrets
      key: mijnAansluitingKeyPassword
{{- end }}
{{- end }}


{{/*
Environment variable mappings for AIIDA region connector
*/}}
{{- define "eddie.region-connectors.aiida.envs" }}
{{- $rcPrefix := "REGION_CONNECTOR_AIIDA" }}
{{- $aiidaValues := .Values.regionConnectors.aiida }}
{{- if eq $aiidaValues.enabled "true" }}
- name: {{ $rcPrefix }}_ENABLED
  value: {{ $aiidaValues.enabled | quote }}
- name: {{ $rcPrefix }}_CUSTOMER_ID
  value: {{ $aiidaValues.customerId | quote }}
- name: {{ $rcPrefix }}_BCRYPT_STRENGTH
  value: {{ $aiidaValues.bcryptStrength | quote }}
- name: {{ $rcPrefix }}_MQTT_SERVER_URI
  value: {{ $aiidaValues.mqtt.serverUri | quote }}
- name: {{ $rcPrefix }}_MQTT_USERNAME
  value: {{ $aiidaValues.mqtt.username | quote }}
- name: {{ $rcPrefix }}_MQTT_PASSWORD
  value: {{ $aiidaValues.mqtt.password | quote }}
{{- end }}
{{- end }}

