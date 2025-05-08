#!/bin/bash
BLACK_TEXT=$'\033[0;90m'
RED_TEXT=$'\033[0;91m'
GREEN_TEXT=$'\033[0;92m'
YELLOW_TEXT=$'\033[0;93m'
BLUE_TEXT=$'\033[0;94m'
MAGENTA_TEXT=$'\033[0;95m'
CYAN_TEXT=$'\033[0;96m'
WHITE_TEXT=$'\033[0;97m'
RESET_FORMAT=$'\033[0m'
BOLD_TEXT=$'\033[1m'
UNDERLINE_TEXT=$'\033[4m'

clear


gcloud auth list


export ZONE=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
echo "${GREEN_TEXT}Zone set to: ${BOLD_TEXT}$ZONE${RESET_FORMAT}"


export REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])")
echo "${GREEN_TEXT}Region set to: ${BOLD_TEXT}$REGION${RESET_FORMAT}"


export PROJECT_ID=$(gcloud config get-value project)
echo "${GREEN_TEXT}Project ID set to: ${BOLD_TEXT}$PROJECT_ID${RESET_FORMAT}"


gcloud config set compute/zone "$ZONE"


gcloud config set compute/region "$REGION"


gsutil cp gs://spls/gsp449/gke-cloud-sql-postgres-demo.tar.gz .


tar -xzvf gke-cloud-sql-postgres-demo.tar.gz


cd gke-cloud-sql-postgres-demo


PG_EMAIL=$(gcloud config get-value account)
echo "${GREEN_TEXT}PostgreSQL admin email will be: ${BOLD_TEXT}$PG_EMAIL${RESET_FORMAT}"


./create.sh dbadmin $PG_EMAIL


for i in $(seq 10 -1 1); do
  echo -ne "${BLUE_TEXT}${BOLD_TEXT} ${i} seconds remaining...${RESET_FORMAT}\r"
  sleep 1
done
echo -ne "\n"
echo "${GREEN_TEXT}${BOLD_TEXT} Resources initialized.${RESET_FORMAT}"


POD_ID=$(kubectl --namespace default get pods -o name | cut -d '/' -f 2)
echo "${GREEN_TEXT}Application Pod ID: ${BOLD_TEXT}$POD_ID${RESET_FORMAT}"


kubectl expose pod $POD_ID --port=80 --type=LoadBalancer


kubectl get svc

echo
echo "${MAGENTA_TEXT}${BOLD_TEXT} Subscribe to QwikLab Explorers ${RESET_FORMAT}"
echo "${BLUE_TEXT}${BOLD_TEXT}${UNDERLINE_TEXT}https://www.youtube.com/@qwiklabexplorers${RESET_FORMAT}"
echo
