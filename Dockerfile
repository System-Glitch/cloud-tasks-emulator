FROM golang:1.25-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .
RUN go build -o emulator .

FROM alpine:latest

LABEL org.opencontainers.image.source=https://github.com/System-Glitch/cloud-tasks-emulator

WORKDIR /

COPY --from=builder /app/oidc.key oidc.key
COPY --from=builder /app/oidc.cert oidc.cert
COPY --from=builder /app/emulator .
COPY --from=builder /app/emulator_from_env.sh .
RUN chmod +x emulator_from_env.sh

ENTRYPOINT ["./emulator"]
