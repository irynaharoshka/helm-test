{{- define "faceapi.config" -}}
# General
{{- if .Values.general.bind }}
FACEAPI_BIND="{{ .Values.general.bind }}"
{{- end }}
FACEAPI_WORKERS="{{ .Values.general.workers }}"
FACEAPI_BACKLOG="{{ .Values.general.backlog }}"
FACEAPI_TIMEOUT="{{ .Values.general.timeout }}"
FACEAPI_ENABLE_DEMO_WEB_APP="{{ .Values.general.demoSite }}"
{{- if .Values.general.licenseUrl }}
FACEAPI_LIC_URL="{{ .Values.general.licenseUrl }}"
{{- end }}
{{- if .Values.general.httpsProxy }}
FACEAPI_HTTPS_PROXY="{{ .Values.general.httpsProxy }}"
{{- end }}

# HTTPS
FACEAPI_HTTPS="{{ .Values.https.enabled }}"

# CORS
{{- if .Values.cors.origins }}
FACEAPI_CORS_ORIGINS="{{ .Values.cors.origins }}"
{{- end }}
{{- if .Values.cors.methods }}
FACEAPI_CORS_METHODS="{{ .Values.cors.methods }}"
{{- end }}
{{- if .Values.cors.headers }}
FACEAPI_CORS_HEADERS="{{ .Values.cors.headers }}"
{{- end }}

# Logs
FACEAPI_LOGS_ACCESS_FILE="{{ .Values.logs.type.accessLog }}"
FACEAPI_LOGS_APP_FILE="{{ .Values.logs.type.appLog }}"
FACEAPI_PROCESS_RESULTS_LOG_FILE="{{ .Values.logs.type.processLog.enabled }}"
FACEAPI_LOGS_PROCESS_SAVE_RESULT="{{ .Values.logs.type.processLog.saveResult }}"
FACEAPI_LOGS_LEVEL="{{ .Values.logs.level }}"
FACEAPI_LOGS_FORMATTER="{{ .Values.logs.format }}"

{{- if .Values.identification.enabled }}
# Identification
FACEAPI_ENABLE_IDENTIFICATION="true"

# PostgreSQL
{{- if and .Values.identification.externalPostgreSQL (not .Values.postgresql.enabled) }}
## Please mind if externalPostgreSQLSecret value is set, it overrides any other PostgreSQL related values
FACEAPI_SQL_URL="{{ .Values.identification.externalPostgreSQL }}"
{{- else if .Values.postgresql.enabled }}
FACEAPI_SQL_URL="postgresql://{{ .Values.postgresql.global.postgresql.auth.username }}:{{ .Values.postgresql.global.postgresql.auth.password }}@{{ template "faceapi.identification.postgresql" . }}:5432/{{ .Values.postgresql.global.postgresql.auth.database }}"
{{- end }}

# Milvus
{{- if .Values.milvus.externalS3.enabled }}
{{- if .Values.milvus.externalS3.useSSL }}
FACEAPI_STORAGE_ENDPOINT="https://{{ .Values.milvus.externalS3.host }}:{{ .Values.milvus.externalS3.port }}"
{{- else }}
FACEAPI_STORAGE_ENDPOINT="http://{{ .Values.milvus.externalS3.host }}:{{ .Values.milvus.externalS3.port }}"
{{- end }}
FACEAPI_STORAGE_ACCESS_KEY="{{ default .Values.milvus.externalS3.accessKey .Values.identification.storageAccessKey }}"
FACEAPI_STORAGE_SECRET_KEY="{{ default .Values.milvus.externalS3.secretKey .Values.identification.storageSecretKey }}"
{{- else }}
FACEAPI_STORAGE_ENDPOINT="{{ template "faceapi.identification.storage_endpoint" . }}"
FACEAPI_STORAGE_ACCESS_KEY="{{ default .Values.milvus.minio.accessKey .Values.identification.storageAccessKey }}"
FACEAPI_STORAGE_SECRET_KEY="{{ default .Values.milvus.minio.secretKey .Values.identification.storageSecretKey }}"
{{- end }}
FACEAPI_STORAGE_REGION="{{ .Values.identification.storageRegion | default "us-east-1" }}"
FACEAPI_STORAGE_PERSON_BUCKET_NAME="{{ default "faceapi-person" .Values.identification.storagePersonBucketName }}"
FACEAPI_STORAGE_SESSION_BUCKET_NAME="{{ default "faceapi-session" .Values.identification.storageSessionBucketName }}"
FACEAPI_MILVUS_HOST="{{ template "faceapi.identification.milvus_host" . }}"
FACEAPI_MILVUS_PORT="{{ default 19530 .Values.identification.milvusPort }}"
{{- end }}
{{- end }}
