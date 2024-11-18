#!/bin/bash

# Variables
COUNTRY="CH"
STATE="Bern"
LOCALITY="Bern"
ORGANIZATION="Example AG"
ORG_UNIT="IT"
COMMON_NAME="John Doe"
EMAIL="john.doe@example.com"

SUBJECT="/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORG_UNIT/CN=$COMMON_NAME/emailAddress=$EMAIL"

PASSWORD="password"

# Private Key
openssl genrsa -out key.pem 2048

#Certificate Signing Request
openssl req -new -key key.pem -out cert.csr -subj $SUBJECT -passout pass:$PASSWORD

# Generating the Self-Signed Certificate
openssl x509 -req -days 365 -in cert.csr -signkey key.pem -out cert.pem
