FROM golang:alpine
MAINTAINER mstuparu

COPY *.go /app/

WORKDIR /app

RUN apk add --no-cache curl

RUN go build -o myapp .

HEALTHCHECK --timeout=3s CMD curl -f http://localhost:8080/ || exit 1

EXPOSE 8080

CMD /app/myapp
