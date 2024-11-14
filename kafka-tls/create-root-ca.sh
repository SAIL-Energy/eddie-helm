#!/bin/bash

source .env

# The root CA can have a very long validity time, here it is set to 5 Years
VALIDITY=1825

# Create Certificate and Private Key for Root CA
openssl req -x509 -config openssl-ca.cnf -newkey rsa:4096 -sha256 -nodes -out root-ca-cert.pem -outform PEM
