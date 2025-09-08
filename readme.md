# grafana-alloy-loki

before running compose file

```bash
# gen root CA
openssl req -x509 -newkey rsa:4096 -sha256 -days 7300 \
  -keyout certs/example-root.key -out certs/example-root.crt \
  -noenc \
  -subj "/CN=example-root" \
  -addext "basicConstraints = CA:TRUE" \
  -addext "keyUsage = critical, cRLSign, keyCertSign" \
  -addext "subjectKeyIdentifier = hash"

# gen CSR for proxy
openssl req -new -newkey rsa:2048 -nodes \
  -keyout certs/proxy.key -out certs/proxy.csr \
  -subj "/CN=proxy" \
  -addext "subjectAltName = DNS:proxy"

# sign proxy cert with root CA
openssl x509 -req -in certs/proxy.csr -CA certs/example-root.crt -CAkey certs/example-root.key \
    -CAcreateserial -out certs/proxy.crt -days 365 -sha256 \
    -extfile <(echo "subjectAltName=DNS:proxy")
```
