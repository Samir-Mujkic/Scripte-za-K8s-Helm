#Dodavanje volumena na vec postojeci volumen tj izmena velicina volumena
#!/bin/bash

# Definiranje variabli
NAMESPACE="default"
DEPLOYMENT_NAME="deployment-nginx"
VOLUME_SIZE="1Gi"

# Provjera  volumena
CURRENT_VOLUME=$(kubectl get deployment -n $NAMESPACE $DEPLOYMENT_NAME -ojsonpath='{.spec.template.spec.volumes[0].emptyDir.sizeLimit}')

# Provjerava je li već postavljeno na 1GB
if [[ "$CURRENT_VOLUME" == "$VOLUME_SIZE" ]]; then
  echo "Volumen je već postavljen na $VOLUME_SIZE. Nema potrebe za ažuriranjem."
  exit 0
fi

# Ažuriraj volumen
kubectl patch deployment -n $NAMESPACE $DEPLOYMENT_NAME --type=json -p="[{\"op\": \"replace\", \"path\": \"/spec/template/spec/volumes/0/emptyDir/sizeLimit\", \"value\":\"$VOLUME_SIZE\"}]"

# Provjeri je li ažuriranje uspješno
UPDATED_VOLUME=$(kubectl get deployment -n $NAMESPACE $DEPLOYMENT_NAME -ojsonpath='{.spec.template.spec.volumes[0].emptyDir.sizeLimit}')
if [[ "$UPDATED_VOLUME" == "$VOLUME_SIZE" ]]; then
  echo "Volumen je uspješno ažuriran na $VOLUME_SIZE."
else
  echo "Greska. Molimo pokušaj ponovno."
  exit 1
fi



