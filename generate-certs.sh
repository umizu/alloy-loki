#!/bin/sh
set -e

CERT_DIR="/certs"

# gen root ca
openssl req -x509 -newkey rsa:4096 -sha256 -days 7300 \
  -keyout "$CERT_DIR/example-root.key" \
  -out "$CERT_DIR/example-root.crt" \
  -nodes \
  -subj "/CN=example-root" \
  -addext "basicConstraints = CA:TRUE" \
  -addext "keyUsage = critical, cRLSign, keyCertSign" \
  -addext "subjectKeyIdentifier = hash"

# gen proxy leaf cert
openssl req -new -newkey rsa:2048 -nodes \
  -keyout "$CERT_DIR/proxy.key" \
  -out "$CERT_DIR/proxy.csr" \
  -subj "/CN=proxy" \
  -addext "subjectAltName = DNS:proxy"
openssl x509 -req -in "$CERT_DIR/proxy.csr" \
  -CA "$CERT_DIR/example-root.crt" \
  -CAkey "$CERT_DIR/example-root.key" \
  -set_serial 01 \
  -out "$CERT_DIR/proxy.crt" \
  -days 365 -sha256 \
  -extfile <(echo "subjectAltName=DNS:proxy")

# gen alloy leaf cert
openssl req -new -newkey rsa:2048 -nodes \
  -keyout "$CERT_DIR/alloy.key" \
  -out "$CERT_DIR/alloy.csr" \
  -subj "/CN=alloy" \
  -addext "subjectAltName = DNS:alloy"
openssl x509 -req -in "$CERT_DIR/alloy.csr" \
  -CA "$CERT_DIR/example-root.crt" \
  -CAkey "$CERT_DIR/example-root.key" \
  -set_serial 02 \
  -out "$CERT_DIR/alloy.crt" \
  -days 365 -sha256 \
  -extfile <(echo "subjectAltName=DNS:proxy")

rm $CERT_DIR/proxy.csr $CERT_DIR/alloy.csr
