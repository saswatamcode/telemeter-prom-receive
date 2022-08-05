./tmp/bin/authorization-server localhost:9101 tokens.json

thanos receive \
  --tsdb.path="$(mktemp -d)" \
  --remote-write.address=127.0.0.1:9105 \
  --label "receive_replica=\"0\"" \
  --grpc-address=127.0.0.1:9106 \
  --http-address=127.0.0.1:9116 \
  --receive.default-tenant-id="FB870BF3-9F3A-44FF-9BF7-D7A047A52F43"

thanos query \
  --grpc-address=127.0.0.1:9107 \
  --http-address=127.0.0.1:9108 \
  --store=127.0.0.1:9106

./tmp/bin/telemeter-server \
  --authorize http://localhost:9101 \
  --listen localhost:9103 \
  --listen-internal localhost:9104 \
  --forward-url=http://localhost:9105/api/v1/receive \
  -v

./tmp/bin/prometheus --config.file=prom.yaml --storage.tsdb.path="$(mktemp -d)"