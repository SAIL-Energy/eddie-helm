#!/bin/bash

source .env

VALIDITY=365
CLIENT_NAME="$1"

if [ -z "$1" ]; then
    CLIENT_NAME=client
fi

# Create Keystore 
keytool -keystore kafka.client-$CLIENT_NAME.keystore.jks -alias localhost -validity $VALIDITY -genkey -keyalg RSA

# Import Root CA Certificate into Keystore
keytool -keystore kafka.client-$CLIENT_NAME.keystore.jks -alias CARoot -import -file root-ca-cert

# Import Root CA Certificate into Truststore
keytool -keystore kafka.client-$CLIENT_NAME.truststore.jks -alias CARoot -import -file root-ca-cert

# Create Certificate Signing Request
keytool -keystore kafka.client-$CLIENT_NAME.keystore.jks -alias localhost -certreq -file client-$CLIENT_NAME-signing-request

# Sign signing request
openssl x509 -req -CA root-ca-cert -CAkey root-ca-key -in client-$CLIENT_NAME-signing-request -out client-$CLIENT_NAME-cert -days $VALIDITY -CAcreateserial
rm client-$CLIENT_NAME-signing-request

# Import Certificate in Keystore
keytool -keystore kafka.client-$CLIENT_NAME.keystore.jks -alias localhost -import -file client-$CLIENT_NAME-cert
