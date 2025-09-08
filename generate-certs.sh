#!/bin/sh
set -e

CERT_DIR="/certs"
mkdir -p "$CERT_DIR"

openssl req -x509 -newkey rsa:4096 -sha256 -days 7300 \
  -keyout "$CERT_DIR/example-root.key" \
  -out "$CERT_DIR/example-root.crt" \
  -nodes \
  -subj "/CN=example-root" \
  -addext "basicConstraints = CA:TRUE" \
  -addext "keyUsage = critical, cRLSign, keyCertSign" \
  -addext "subjectKeyIdentifier = hash"

openssl req -new -newkey rsa:2048 -nodes \
  -keyout "$CERT_DIR/proxy.key" \
  -out "$CERT_DIR/proxy.csr" \
  -subj "/CN=proxy" \
  -addext "subjectAltName = DNS:proxy"
echo "subjectAltName=DNS:proxy" > "$CERT_DIR/proxy.ext"
openssl x509 -req -in "$CERT_DIR/proxy.csr" \
  -CA "$CERT_DIR/example-root.crt" \
  -CAkey "$CERT_DIR/example-root.key" \
  -set_serial 01 \
  -out "$CERT_DIR/proxy.crt" \
  -days 365 -sha256 \
  -extfile "$CERT_DIR/proxy.ext"

openssl req -new -newkey rsa:2048 -nodes \
  -keyout "$CERT_DIR/alloy.key" \
  -out "$CERT_DIR/alloy.csr" \
  -subj "/CN=alloy" \
  -addext "subjectAltName = DNS:alloy"
echo "subjectAltName=DNS:alloy" > "$CERT_DIR/alloy.ext"
openssl x509 -req -in "$CERT_DIR/alloy.csr" \
  -CA "$CERT_DIR/example-root.crt" \
  -CAkey "$CERT_DIR/example-root.key" \
  -set_serial 02 \
  -out "$CERT_DIR/alloy.crt" \
  -days 365 -sha256 \
  -extfile "$CERT_DIR/alloy.ext"
