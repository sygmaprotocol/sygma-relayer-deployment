FROM golang:alpine3.17 as sygma
ARG OTEL_VERSION=0.75
WORKDIR /app
COPY otlp-builder.yml .
RUN go install go.opentelemetry.io/collector/cmd/builder@v${OTEL_VERSION}
RUN builder --config=otlp-builder.yml

FROM gcr.io/distroless/base-debian11
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=sygma /app/bin/otelcol-sygma /
COPY otlp-config.yml /etc/otelcol-contrib/config.yml
EXPOSE 4317/tcp 4318/tcp 55678/tcp 55679/tcp 8888/tcp 443 4448 4319 9000 9001
CMD ["--config", "/etc/otelcol-contrib/config.yml"]
ENTRYPOINT ["/otelcol-sygma"]