#!/bin/bash

# Set the namespace and deployment name
NAMESPACE="default"
DEPLOYMENT_NAME="deployment-nginx"

# Set the path to the config.yaml file
CONFIG_PATH="config.yaml"

# Create the ConfigMap
kubectl create configmap moj-nginx-configmap --from-file="$CONFIG_PATH" -n "$NAMESPACE"

# Add the ConfigMap to the deployment's volume
kubectl patch deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" --patch='
spec:
   template:
    spec:
      volumes:
        - name: config-volume
          configMap:
            name: moj-nginx-configmap
      containers:
        - name: nginx
          volumeMounts:
            - name: config-volume
              mountPath: /app/config
'
