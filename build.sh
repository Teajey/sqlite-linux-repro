docker run --rm -v "$PWD":/usr/src/app -w /usr/src/app golang:1.22 env GOOS=linux GOARCH=amd64 CGO_ENABLED=1 go build .
