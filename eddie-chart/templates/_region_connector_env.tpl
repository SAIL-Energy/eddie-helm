{{/*
Environment variable mappings for AT EDA region connector
*/}}
{{- define "eddie.region-connector-env.at-eda" }}
- name: REGION_CONNECTOR_AT_EDA_ENABLED
  value: {{ .Values.regionConnectors.atEda.enabled | quote }}
- name: REGION_CONNECTOR_AT_EDA_ELIGIBLEPARTY_ID
  value: {{ .Values.regionConnectors.atEda.eligiblePartyId | quote }}
- name: REGION_CONNECTOR_AT_EDA_PONTON_MESSENGER_ADAPTER_ID
  value: {{ .Values.regionConnectors.atEda.pontonMessenger.adapter.id | quote }}
- name: REGION_CONNECTOR_AT_EDA_PONTON_MESSENGER_ADAPTER_VERSION
  value: {{ .Values.regionConnectors.atEda.pontonMessenger.adapter.version | quote }}
- name: REGION_CONNECTOR_AT_EDA_PONTON_MESSENGER_HOSTNAME
  value: {{ .Values.regionConnectors.atEda.pontonMessenger.hostname | quote }}
- name: REGION_CONNECTOR_AT_EDA_PONTON_MESSENGER_API_ENDPOINT
  value: {{ .Values.regionConnectors.atEda.pontonMessenger.apiEndpoint | quote }}
- name: REGION_CONNECTOR_AT_EDA_PONTON_MESSENGER_PORT
  value: {{ .Values.regionConnectors.atEda.pontonMessenger.port | quote }}
- name: REGION_CONNECTOR_AT_EDA_PONTON_MESSENGER_FOLDER
  value: {{ .Values.regionConnectors.atEda.pontonMessenger.folder | quote }}
- name: REGION_CONNECTOR_AT_EDA_PONTON_MESSENGER_USERNAME
  value: {{ .Values.regionConnectors.atEda.pontonMessenger.username | quote }}
- name: REGION_CONNECTOR_AT_EDA_PONTON_MESSENGER_PASSWORD
  value: {{ .Values.regionConnectors.atEda.pontonMessenger.password | quote }}
{{- end }}

{{/*
Environment variable mappings for FR ENEDIS region connector
*/}}
{{- define "eddie.region-connector-env.fr-enedis" }}
- name: REGION_CONNECTOR_FR_ENEDIS_BASEPATH
  value: {{ .Values.regionConnectors.frEnedis.basePath | quote }}
- name: REGION_CONNECTOR_FR_ENEDIS_CLIENT_ID
  value: {{ .Values.regionConnectors.frEnedis.client.id | quote }}
- name: REGION_CONNECTOR_FR_ENEDIS_CLIENT_SECRET
  value: {{ .Values.regionConnectors.frEnedis.client.secret | quote }}
- name: REGION_CONNECTOR_FR_ENEDIS_POLLING
  value: {{ .Values.regionConnectors.frEnedis.polling | quote }}
{{- end }}
