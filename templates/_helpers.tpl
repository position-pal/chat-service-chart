{{- define "cassandra.waitForDatabase" -}}
initContainers:
    - name: wait-for-cassandra
      image: bitnami/cassandra:latest
      command:
          - /bin/bash
          - -c
          - |
              until cqlsh ${CASSANDRA_HOST} ${CASSANDRA_PORT} -u ${CASSANDRA_USERNAME} -p ${CASSANDRA_PASSWORD} -e "DESC KEYSPACES;" >/dev/null 2>&1; do
              echo "Waiting for Cassandra to be ready..."
              sleep 5
              done
              echo "Cassandra is ready!"
      env:
        - name: CASSANDRA_HOST
          value: {{ .Release.Name }}-cassandra.{{ .Release.Namespace }}.svc.cluster.local
        - name: CASSANDRA_PORT
          value: "9042"
        - name: CASSANDRA_USERNAME
          value: {{ .Values.cassandra.dbUser.user | quote }}
        - name: CASSANDRA_PASSWORD
          valueFrom:
            secretKeyRef:
              name: {{ .Release.Name }}-location-service-secrets
              key: cassandra-password

{{- end -}}

{{- define "chat-service.labels" -}}
app: {{ .Values.config.servicename }}
{{- end -}}

{{- define "chat-service.container" -}}
- name: {{ .Values.config.servicename }}
  image: "{{ .Values.config.image.repository }}:{{ .Values.config.image.tag }}"
  readinessProbe:
    httpGet:
      path: /ready
      port: management
  livenessProbe:
    httpGet:
      path: /alive
      port: management
  ports:
  - name: management
    containerPort: {{ .Values.config.managementPort }}
    protocol: TCP
  - name: http
    containerPort: {{ .Values.config.httpPort }}
    protocol: TCP
  - name: grpc
    containerPort: {{ .Values.config.grpcPort }}
    protocol: TCP
  resources:
    limits:
      memory: 2Gi
    requests:
      cpu: 2
      memory: 1024Mi
  env:
    - name: AKKA_LICENSE_KEY
      valueFrom:
        secretKeyRef:
          name: {{ .Release.Name }}-location-service-secrets
          key: akka-license-key
    - name: NAMESPACE
      valueFrom:
        fieldRef:
          fieldPath: metadata.namespace
    - name: RABBITMQ_PASSWORD
      valueFrom:
        secretKeyRef:
          name: {{ .Release.Name }}-location-service-secrets
          key: rabbitmq-password
    - name: CASSANDRA_CONTACT_POINT
      value: {{ .Release.Name }}-cassandra.{{ .Release.Namespace }}.svc.cluster.local:9042
    - name: CASSANDRA_USERNAME
      value: {{ .Values.cassandra.dbUser.user | quote }}
    - name: CASSANDRA_PASSWORD
      valueFrom:
        secretKeyRef:
          name: {{ .Release.Name }}-location-service-secrets
          key: cassandra-password
    - name: RABBITMQ_VIRTUAL_HOST
      value: {{ .Values.rabbitmq.virtualHost | quote }}
    - name: RABBITMQ_HOST
      value: "{{ .Values.rabbitmq.serviceName }}.{{ .Values.rabbitmq.namespace }}.svc.cluster.local"
    - name: RABBITMQ_PORT
      value: {{ .Values.rabbitmq.port | quote }}
    - name: RABBITMQ_USERNAME
      value: {{ .Values.rabbitmq.username | quote }}
    - name: USER_SERVICE_EVENT_QUEUE
      value: {{ .Values.rabbitmq.userServiceEventQueue | quote }}
    - name: GRPC_PORT
      value: {{ .Values.config.grpcPort | quote }}
    - name: HTTP_PORT
      value: {{ .Values.config.httpPort | quote }}
    - name: REQUIRED_CONTACT_POINT_NR
      value: {{ .Values.config.requiredContactPointNr | quote }}
{{- end -}}
