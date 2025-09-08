# grafana-alloy-loki

generate cert with the following command before running compose file

```bash
openssl req -x509 -out certs/example.crt -keyout certs/example.key -newkey rsa:2048 -noenc -sha256 -subj '/CN=proxy' -extensions EXT -config <( \
   printf "[dn]\nCN=proxy\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:proxy\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")
```
