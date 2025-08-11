# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Build
```bash
make build
```
Builds the `auger` binary to `build/auger`. Cross-platform builds supported via GOOS/GOARCH environment variables.

### Test
```bash
make test
```
Runs `go vet ./...` followed by `go test ./...`

### Lint/Format
```bash
make fmt
```
Verifies gofmt and goimports formatting. Use `./scripts/fix.sh` to auto-fix formatting issues.

```bash
make verify
```
Runs golangci-lint with configuration from `tools/.golangci.yaml`

### Generate
```bash
make generate
```
Regenerates `pkg/scheme/scheme.go` using `hack/gen_scheme.sh`. This file is auto-generated and should not be edited manually.

### Clean
```bash
make clean
```
Removes the `build/` directory

## Architecture

### Core Purpose
Auger is a tool for accessing and manipulating Kubernetes objects stored in etcd's binary format. It provides encoding/decoding capabilities between etcd's binary storage format and human-readable formats (YAML, JSON, Protobuf).

### Main Components

#### Two Binary Targets
- **auger** (`main.go` + `cmd/`): Main CLI tool for etcd data manipulation
- **augerctl** (`augerctl/main.go`): Alternative control interface

#### Key Packages
- **`pkg/encoding/`**: Core encoding/decoding logic between binary and text formats
- **`pkg/scheme/`**: Auto-generated Kubernetes API scheme registration (supports standard K8s APIs + custom resources like volcano.sh and notebook-crd)  
- **`pkg/client/`**: etcd client utilities and data access logic
- **`pkg/data/`**: Data structure definitions and manipulation

#### Command Structure
- **`cmd/`**: Main command implementations (encode, decode, extract, analyze, checksum)
- **`augerctl/command/`**: Alternative CLI command implementations with get/version subcommands

### Key Features
- **Binary Format Support**: Handles both JSON (K8s 1.5-) and binary (K8s 1.6+) etcd storage formats
- **Multi-format Output**: Supports YAML, JSON, and Protobuf output
- **Direct Database Access**: Can read directly from boltdb files without running etcd
- **Custom Resource Support**: Includes support for Volcano jobs and custom notebook CRDs
- **Consistency Checking**: Provides checksum verification for etcd cluster consistency

### Development Notes
- The codebase uses Go modules with toolchain go1.24.2
- Extensive golangci-lint rules configured in `tools/.golangci.yaml`
- Auto-generated scheme file supports 40+ Kubernetes API versions plus custom resources
- Scripts in `scripts/` directory handle various deployment and processing tasks