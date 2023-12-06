#!/bin/bash

# Definiranje variabli
NAMESPACE="default"
DEPLOYMENT_NAME="production-nginx"
VOLUME_NAME="data-volume"
VOLUME_SIZE="500Mi"

# Dodavaje volumena u deployment
kubectl -n $NAMESPACE patch deployment $DEPLOYMENT_NAME --type=json -p='[{"op": "add", "path": "/spec/template/spec/volumes", "value": [{"name": "'$VOLUME_NAME'","emptyDir": {"sizeLimit": "'$VOLUME_SIZE'"}}]}]'

# Postavljanje volumena u container
kubectl -n $NAMESPACE patch deployment $DEPLOYMENT_NAME --type=json -p='[{"op": "add", "path": "/spec/template/spec/containers/0/volumeMounts", "value": [{"name": "'$VOLUME_NAME'","mountPath": "/data"}]}]'
