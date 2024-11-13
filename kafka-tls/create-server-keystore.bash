#!/usr/bin/bash

source .env

keytool -keystore server.keystore.jks \
        -storepass "${KEYSTORE_PASSWORD}" \
        -dname "CN=${HOSTNAME_FOR_KAFKA}" \
        -alias "${HOSTNAME_FOR_KAFKA}" \
        -validity 366 \
        -genkey \
        -keyalg RSA \
        -storetype pkcs12

keytool -keystore server.keystore.jks \
		-storepass "${KEYSTORE_PASSWORD}" \
		-alias "${HOSTNAME_FOR_KAFKA}" \
		-certreq \
		-file server-cert-file-request