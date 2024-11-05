{{/*
Environment variable mappings for AT EDA region connector
*/}}
{{- define "eddie.region-connectors.at-eda.envs" }}
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
{{- define "eddie.region-connectors.fr-enedis.envs" }}
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
{{- define "eddie.region-connectors.dk-energinet.envs" }}
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
{{- define "eddie.region-connectors.es-datadis.envs" }}
{{- $datadisValues := .Values.regionConnectors.esDatadis }}
- name: REGION_CONNECTOR_ES_DATADIS_ENABLED
  value: {{ $datadisValues.enabled | quote }}
- name: REGION_CONNECTOR_ES_DATADIS_USERNAME
  value: {{ $datadisValues.username | quote }}
- name: REGION_CONNECTOR_ES_DATADIS_PASSWORD
  value: {{ $datadisValues.password | quote }}
- name: REGION_CONNECTOR_ES_DATADIS_POLLING
  value: {{ $datadisValues.polling | quote }}
- name: REGION_CONNECTOR_ES_DATADIS_RETRY
  value: {{ $datadisValues.retry | quote }}
- name: REGION_CONNECTOR_ES_DATADIS_BASEPATH
  value: {{ $datadisValues.basePath | quote }}
{{- end }}

{{/*
Environment variable mappings for US Green Button region connector
*/}}
{{- define "eddie.region-connectors.us-green-button.envs" }}
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
- name: REGION_CONNECTOR_FI_FINGRID_ENABLED
  value: {{ $fingridValues.enabled | quote }}
- name: REGION_CONNECTOR_FI_FINGRID_API_URL
  value: {{ $fingridValues.apiUrl | quote }}
- name: REGION_CONNECTOR_FI_FINGRID_ORGANISATION_USER
  value: {{ $fingridValues.organisation.user | quote }}
- name: REGION_CONNECTOR_FI_FINGRID_ORGANISATION_NAME
  value: {{ $fingridValues.organisation.name | quote }}
- name: SPRING_SSL_BUNDLE_JKS_FINGRID_KEYSTORE_LOCATION
  value: "/opt/fingrid-keystore/fingrid.jks"
- name: SPRING_SSL_BUNDLE_JKS_FINGRID_KEYSTORE_TYPE
  value: "JKS"
- name: SPRING_SSL_BUNDLE_JKS_FINGRID_KEYSTORE_PASSWORD
  value: {{ $fingridValues.keystore.password | quote }}
- name: SPRING_SSL_BUNDLE_JKS_FINGRID_KEY_ALIAS
  value: {{ $fingridValues.keystore.key.alias | quote }}
- name: SPRING_SSL_BUNDLE_JKS_FINGRID_KEY_PASSWORD
  value: {{ $fingridValues.keystore.key.password | quote }}
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
- name: REGION_CONNECTOR_NL_MIJN_AANSLUITING_ENABLED
  value: {{ $aansluitingValues.enabled | quote }}
- name: REGION_CONNECTOR_NL_MIJN_AANSLUITING_ISSUER_URL
  value: {{ $aansluitingValues.issuerUrl | quote }}
- name: SPRING_SSL_BUNDLE_JKS_NL_KEYSTORE_REDIRECT_URL
  value: {{ $aansluitingValues.redirectUrl | quote }}
- name: REGION_CONNECTOR_NL_MIJN_AANSLUITING_SINGLE_KEY_ID
  value: {{ $aansluitingValues.single.keyId | quote }}
- name: REGION_CONNECTOR_NL_MIJN_AANSLUITING_SINGLE_CLIENT_ID
  value: {{ $aansluitingValues.single.clientId | quote }}
- name: REGION_CONNECTOR_NL_MIJN_AANSLUITING_SINGLE_SCOPE
  value: {{ $aansluitingValues.single.scope | quote }}
- name: REGION_CONNECTOR_NL_MIJN_AANSLUITING_CONTINUOUS_KEY_ID
  value: {{ $aansluitingValues.continuous.keyId | quote }}
- name: REGION_CONNECTOR_NL_MIJN_AANSLUITING_CONTINUOUS_CLIENT_ID
  value: {{ $aansluitingValues.continuous.clientId | quote }}
- name: REGION_CONNECTOR_NL_MIJN_AANSLUITING_CONTINUOUS_SCOPE
  value: {{ $aansluitingValues.continuous.scope | quote }}
- name: SPRING_SSL_BUNDLE_JKS_NL_KEYSTORE_LOCATION
  value: "/opt/aansluiting-keystore/aansluiting.jks"
- name: SPRING_SSL_BUNDLE_JKS_NL_KEYSTORE_TYPE
  value: "JKS"
- name: SPRING_SSL_BUNDLE_JKS_NL_KEYSTORE_PASSWORD
  value: {{ $aansluitingValues.keystore.password | quote }}
- name: SPRING_SSL_BUNDLE_JKS_NL_KEY_ALIAS
  value: {{ $aansluitingValues.keystore.key.alias | quote }}
- name: SPRING_SSL_BUNDLE_JKS_NL_KEY_PASSWORD
  value: {{ $aansluitingValues.keystore.key.password | quote }}
{{- end }}
