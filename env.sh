#!/bin/bash -e

# url of the source elasticsearch from which data will be dump
es_source_url="https://34.244.42.130:9200"
# url of the destination elasticsearch into witch data will be load
es_dest_url="https://34.254.158.55:9200"
# The folder where data will be dumped
data_folder="./data"
# comment this line if you don't use tls authentication between ES client and ES cluster
tsl_enabled=true
# Client certificate file path
client_cert_path=./cert.pem
# Private key file path
client_key_path=./key.pem

getCommand() {
  ES_DUMP_CMD="elasticdump"
  if [ "$tsl_enabled" == "true" ]; then
    ES_DUMP_CMD="NODE_TLS_REJECT_UNAUTHORIZED=0 elasticdump --tlsAuth --cert $client_cert_path --key $client_key_path"
  fi
  echo "$ES_DUMP_CMD"
}
