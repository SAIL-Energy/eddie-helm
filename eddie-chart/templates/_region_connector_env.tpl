{{/*
Environment variable mappings for AT EDA region connector
*/}}
{{- define "eddie.region-connector-env.at-eda" }}
{{- $edaValues := .Values.regionConnectors.atEda }}
{{- $pontonValues := .Values.regionConnectors.atEda.pontonMessenger }}
- name: REGION_CONNECTOR_AT_EDA_ENABLED
  value: {{ $edaValues.enabled | quote }}
- name: REGION_CONNECTOR_AT_EDA_ELIGIBLEPARTY_ID
  value: {{ $edaValues.eligiblePartyId | quote }}
- name: REGION_CONNECTOR_AT_EDA_PONTON_MESSENGER_ADAPTER_ID
  value: {{ $pontonValues.adapter.id | quote }}
- name: REGION_CONNECTOR_AT_EDA_PONTON_MESSENGER_ADAPTER_VERSION
  value: {{ $pontonValues.adapter.version | quote }}
- name: REGION_CONNECTOR_AT_EDA_PONTON_MESSENGER_HOSTNAME
  value: {{ $pontonValues.hostname | quote }}
- name: REGION_CONNECTOR_AT_EDA_PONTON_MESSENGER_API_ENDPOINT
  value: {{ $pontonValues.apiEndpoint | quote }}
- name: REGION_CONNECTOR_AT_EDA_PONTON_MESSENGER_PORT
  value: {{ $pontonValues.port | quote }}
- name: REGION_CONNECTOR_AT_EDA_PONTON_MESSENGER_FOLDER
  value: {{ $pontonValues.folder | quote }}
- name: REGION_CONNECTOR_AT_EDA_PONTON_MESSENGER_USERNAME
  value: {{ $pontonValues.username | quote }}
- name: REGION_CONNECTOR_AT_EDA_PONTON_MESSENGER_PASSWORD
  value: {{ $pontonValues.password | quote }}
{{- end }}

{{/*
Environment variable mappings for FR ENEDIS region connector
*/}}
{{- define "eddie.region-connector-env.fr-enedis" }}
{{- $enedisValues := .Values.regionConnectors.frEnedis }}
- name: REGION_CONNECTOR_FR_ENEDIS_ENABLED
  value: {{ $enedisValues.enabled | quote }}
- name: REGION_CONNECTOR_FR_ENEDIS_BASEPATH
  value: {{ $enedisValues.basePath | quote }}
- name: REGION_CONNECTOR_FR_ENEDIS_CLIENT_ID
  value: {{ $enedisValues.client.id | quote }}
- name: REGION_CONNECTOR_FR_ENEDIS_CLIENT_SECRET
  value: {{ $enedisValues.client.secret | quote }}
- name: REGION_CONNECTOR_FR_ENEDIS_POLLING
  value: {{ $enedisValues.polling | quote }}
{{- end }}

{{/*
Environment variable mappings for DK ENERGINET region connector
*/}}
{{- define "eddie.region-connector-env.dk-energinet" }}
- name: REGION_CONNECTOR_DK_ENERGINET_ENABLED
  value: {{ .Values.regionConnectors.dkEnerginet.enabled | quote }}
- name: REGION_CONNECTOR_DK_ENERGINET_CUSTOMER_CLIENT_BASEPATH
  value: {{ .Values.regionConnectors.dkEnerginet.customer.client.basePath | quote }}
- name: REGION_CONNECTOR_DK_ENERGINET_CUSTOMER_CLIENT_ID
  value: {{ .Values.regionConnectors.dkEnerginet.customer.client.id | quote }}
- name: REGION_CONNECTOR_DK_ENERGINET_POLLING
  value: {{ .Values.regionConnectors.dkEnerginet.polling | quote }}
- name: REGION_CONNECTOR_DK_ENERGINET_RETRY
  value: {{ .Values.regionConnectors.dkEnerginet.retry | quote }}
{{- end }}

{{/*
Environment variable mappings for ES Datadis region connector
*/}}
{{- define "eddie.region-connector-env.es-datadis" }}
- name: REGION_CONNECTOR_ES_DATADIS_ENABLED
  value: {{ .Values.regionConnectors.esDatadis.enabled | quote }}
- name: REGION_CONNECTOR_ES_DATADIS_USERNAME
  value: {{ .Values.regionConnectors.esDatadis.username | quote }}
- name: REGION_CONNECTOR_ES_DATADIS_PASSWORD
  value: {{ .Values.regionConnectors.esDatadis.password | quote }}
- name: REGION_CONNECTOR_ES_DATADIS_POLLING
  value: {{ .Values.regionConnectors.esDatadis.polling | quote }}
- name: REGION_CONNECTOR_ES_DATADIS_RETRY
  value: {{ .Values.regionConnectors.esDatadis.retry | quote }}
- name: REGION_CONNECTOR_ES_DATADIS_BASEPATH
  value: {{ .Values.regionConnectors.esDatadis.basePath | quote }}
{{- end }}

{{/*
Environment variable mappings for US Green Button region connector
*/}}
{{- define "eddie.region-connector-env.us-green-button" }}
{{- $greenButtonValues := .Values.regionConnectors.usGreenButton }}
- name: REGIONCONNECTOR_US_GREEN_BUTTON_ENABLED
  value: {{ $greenButtonValues.enabled | quote }}
- name: REGIONCONNECTOR_US_GREEN_BUTTON_BASEPATH
  value: {{ $greenButtonValues.basePath | quote }}
- name: REGIONCONNECTOR_US_GREEN_BUTTON_REDIRECTURI
  value: {{ $greenButtonValues.redirectUrl | quote }}
- name: REGIONCONNECTOR_US_GREEN_BUTTON_APITOKEN
  value: {{ $greenButtonValues.client.apiToken | quote }}
- name: REGIONCONNECTOR_US_GREEN_BUTTON_WEBHOOK_SECRET
  value: {{ $greenButtonValues.webhookSecret | quote }}
- name: REGIONCONNECTOR_US_GREEN_BUTTON_ACTIVATIONBATCHSIZE
  value: {{ $greenButtonValues.activationBatchSize | quote }}
{{- range $greenButtonValues.clients }}
- name: REGIONCONNECTOR_US_GREEN_BUTTON_CLIENTIDS_{{ .name }}
  value: {{ .id | quote }}
- name: REGIONCONNECTOR_US_GREEN_BUTTON_CLIENTSECRETS_{{ .name }}
  value: {{ .secret | quote }}
{{- end }}
{{- end }}

