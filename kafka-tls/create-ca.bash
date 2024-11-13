#!/usr/bin/bash

source .env

openssl req -x509 -config openssl-ca.cnf -newkey rsa:4096 -sha256 -nodes -out cacert.pem -outform PEM

keytool -keystore server.truststore.jks \
    -storepass "${KEYSTORE_PASSWORD}" \
    -alias CARoot \
    -storetype pkcs12 \
    -import \
    -file cacert.pem

keytool -keystore client.truststore.jks \
    -storepass "${TRUSTSTORE_PASSWORD}" \
    -alias CARoot \
    -storetype pkcs12 \
    -import \
    -file cacert.pem