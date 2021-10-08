{{- define "algorand.pod" -}}

{{- if .Values.image.pullSecrets }}
imagePullSecrets:
{{- toYaml .Values.image.pullSecrets | nindent 2 }}
{{- end }}
serviceAccountName: {{ include "algorand.serviceAccountName" . }}
{{- if .Values.podSecurityContext }}
securityContext:
{{- toYaml .Values.podSecurityContext | nindent 2 }}
{{- end }}
containers:
  - name: {{ .Chart.Name }}
    {{- if .Values.containerSecurityContext }}
    securityContext:
    {{- toYaml .Values.containerSecurityContext | nindent 8 }}
    {{- end }}
    image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
    imagePullPolicy: {{ .Values.image.pullPolicy }}
    {{- with .Values.image.command }}
    command:
    {{- toYaml . | nindent 8 }}
    {{- end }}
    {{- with .Values.image.args }}
    args:
    {{- toYaml . | nindent 8 }}
    {{- end }}
    ports: []
    env:
      - name: POD_NAME
        valueFrom:
          fieldRef:
            fieldPath: metadata.name
      - name: POD_NAMESPACE
        valueFrom:
          fieldRef:
            fieldPath: metadata.namespace
      - name: ALGORAND_DATA
        value: /opt/data
    volumeMounts:
      - name: {{ template "algorand.fullname" . }}
        mountPath: /opt
        {{- if .Values.storage.subPath }}
        subPath: {{ .Values.storage.subPath }}
        {{- end }}
    resources:
      {{- toYaml .Values.resources | nindent 10 }}
#   - name: carpenter-sidecar
#     image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
#     command: ["/bin/sh"]
#     args: ["-c", "/root/node/carpenter -D"]
initContainers:
  - name: init-algorand-data
    image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
    command: ["/bin/sh"]
    args: ["-c", "/root/node/goal node create --destination /opt/data --network mainnet || true"]
    env:
      - name: ALGORAND_DATA
        value: /opt/data
    volumeMounts:
      - name: {{ template "algorand.fullname" . }}
        mountPath: /data
        {{- if .Values.storage.subPath }}
        subPath: {{ .Values.storage.subPath }}
        {{- end }}

volumes:
  - name: config
    configMap:
      name: {{ include "algorand.fullname" . }}

{{- with .Values.nodeSelector }}
nodeSelector:
{{- toYaml . | nindent 2 }}
{{- end }}

{{- with .Values.affinity }}
affinity:
{{- toYaml . | nindent 2 }}
{{- end }}

{{- with .Values.tolerations }}
tolerations:
{{- toYaml . | nindent 2 }}
{{- end }}

{{- end }}
