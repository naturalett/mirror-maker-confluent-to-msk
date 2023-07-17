{{/*
Expand the name of the chart.
*/}}
{{- define "cp-kafka-connect.name" -}}
{{- default .Chart.Name .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "cp-kafka-connect.imageName" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "cp-kafka-connect.fullname" -}}
{{ include "cp-kafka-connect.name" . }}
{{- end }}

{{- define "cp-kafka-connect.shortenv" -}}
{{- .Values.shortenv | default "staging" }}
{{- end }}

{{- define "cp-kafka-connect.ingress" -}}
{{ index .Values .Release.Name "ingress" "host" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cp-kafka-connect.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cp-kafka-connect.labels" -}}
helm.sh/chart: {{ include "cp-kafka-connect.chart" . }}
{{ include "cp-kafka-connect.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}


{{/*
Selector labels
*/}}
{{- define "cp-kafka-connect.selectorLabels" -}}
app: {{ include "cp-kafka-connect.name" . }}
{{- end }}

