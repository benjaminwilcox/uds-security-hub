# Set the shell to bash
SHELL := /bin/bash

# Default target
all: build

# Build the project
build:
	go build -o bin/uds-security-hub main.go
	go build -o bin/table-init ./cmd/table-init/main.go
	go build -o bin/store ./cmd/store/main.go

# Lint the code
lint:
	 golangci-lint run ./...

# Clean the build
clean:
	rm -rf bin/

test: test-unit test-integration

test-unit: 
	go test -timeout 160s ./... -v -coverprofile=coverage.out

test-integration: 
	@if [ -z "$${GITHUB_TOKEN}" ] || [ -z "$${GHCR_CREDS}" ]; then \
		echo "Error: GITHUB_TOKEN or GHCR_CREDS is not set"; \
		exit 1; \
	fi
	integration=true go test -timeout 160s ./... -v -coverprofile=coverage.out

.PHONY: all build test lint run clean e2e table-init
