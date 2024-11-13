#!/usr/bin/bash

source .env

openssl ca -config openssl-ca.cnf -policy signing_policy -extensions signing_req -out server.cert -infiles server-cert-file-request

keytool -keystore server.keystore.jks \
    -storepass "${KEYSTORE_PASSWORD}" \
    -alias CARoot \
    -import -file cacert.pem

keytool -keystore server.keystore.jks \
    -storepass "${KEYSTORE_PASSWORD}" \
    -alias "${HOSTNAME_FOR_KAFKA}" \
    -import -file 01.pem