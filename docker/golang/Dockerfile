FROM golang:1.18-alpine3.15 AS builder
WORKDIR /app

COPY go.* .
RUN go mod download

COPY . .
RUN go build main.go

FROM alpine:3.15
RUN apk add ca-certificates
WORKDIR /app
RUN mkdir -p /app
RUN addgroup -g 1011 go
RUN adduser -D -u 1011 go -G go 
COPY --chown=go:go --from=builder /app/main /app/main
USER go

EXPOSE 5000

CMD /app/main






