SHELL := /bin/bash
BASEDIR = $(shell pwd)
export GO111MODULE=on
export GOPROXY=https://goproxy.cn,direct
export GOSUMDB=off

APP_NAME=localize
APP_VERSION=2.0.0
IMAGE_NAME="catchzeng/${APP_NAME}:${APP_VERSION}"
IMAGE_LATEST="catchzeng/${APP_NAME}:latest"

fmt:
	gofmt -w .
mod:
	go mod tidy
lint:
	golangci-lint run
.PHONY: test
test:
	go test -coverpkg=./... -coverprofile=coverage.data ./...
.PHONY: build
build:
	go build -o ${APP_NAME} main.go
build-mac:
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -o ${APP_NAME} main.go
build-linux:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o ${APP_NAME} main.go
build-win:
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -o ${APP_NAME}.exe main.go
build-win32:
	CGO_ENABLED=0 GOOS=windows GOARCH=386 go build -o ${APP_NAME}.exe main.go
build-docker:
	echo ${IMAGE_NAME}; \
	docker build --build-arg tmp_app_name=${APP_NAME} -t ${IMAGE_NAME} -f Dockerfile .
push-docker: build-docker
	docker tag ${IMAGE_NAME} ${IMAGE_LATEST};
	docker push ${IMAGE_NAME};
	docker push ${IMAGE_LATEST};
help:
	@echo "fmt - go format"
	@echo "mod - go mod tidy"
	@echo "lint - run golangci-lint"
	@echo "test - unit test"
	@echo "build - build binary"
	@echo "build-mac - build mac binary"
	@echo "build-linux - build linux amd64 binary"
	@echo "build-win - build win amd64 binary"
	@echo "build-win32 - build win 386 binary"
	@echo "build-docker - build docker image"
	@echo "push-docker - push docker image to docker hub"