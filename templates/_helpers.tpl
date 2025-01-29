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