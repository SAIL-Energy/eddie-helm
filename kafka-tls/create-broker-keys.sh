#!/bin/bash

source .env

# Message Brokers can have a longer validity than the clients, but not as long as the root ca, here it is set to 1 year
VALIDITY=365
BROKER_ID="$1"

if [ -z "$1" ]; then
    BROKER_ID=0
fi

# Create Keystore 
keytool -keystore kafka.broker-$BROKER_ID.keystore.jks \
                  -alias $HOSTNAME_FOR_KAFKA \
                  -validity $VALIDITY \
                  -storepass $KEYSTORE_PASSWORD \
                  -genkey -keyalg RSA \
                  -dname "CN=$HOSTNAME_FOR_KAFKA" \
                  -ext san=dns:$HOSTNAME_FOR_KAFKA 

# Import Root CA Certificate into Keystore
keytool -keystore kafka.broker-$BROKER_ID.keystore.jks \
                  -storepass $KEYSTORE_PASSWORD \
                  -alias CARoot -import -file root-ca-cert.pem

# Import Root CA Certificate into Truststore and create truststore
keytool -keystore kafka.broker-$BROKER_ID.truststore.jks \
                  -storepass $TRUSTSTORE_PASSWORD \
                  -alias CARoot -import -file root-ca-cert.pem

# Create Certificate Signing Request
keytool -keystore kafka.broker-$BROKER_ID.keystore.jks \
                  -storepass $KEYSTORE_PASSWORD \
                  -alias $HOSTNAME_FOR_KAFKA -certreq \
                  -file broker-$BROKER_ID-signing-request \
                  -ext san=dns:$HOSTNAME_FOR_KAFKA 

# Sign signing request 
openssl x509 -req -CA root-ca-cert.pem -CAkey root-ca-key.pem \
                  -in broker-$BROKER_ID-signing-request \
                  -out broker-$BROKER_ID-cert.pem \
                  -days $VALIDITY -CAcreateserial \
                  -copy_extensions copyall

# Import Certificate in Keystore
keytool -keystore kafka.broker-$BROKER_ID.keystore.jks \
                  -storepass $KEYSTORE_PASSWORD \
                  -alias $HOSTNAME_FOR_KAFKA -import -file broker-$BROKER_ID-cert.pem

mkdir $BROKER_ID
mv broker-$BROKER_ID-signing-request $BROKER_ID\
mv kafka.broker-$BROKER_ID.truststore.jks $BROKER_ID\
mv kafka.broker-$BROKER_ID.keystore.jks $BROKER_ID\
