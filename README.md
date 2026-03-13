# Platform Contracts

Centralized protobuf contracts and API definitions for the PeopleSuite platform. This repository is the single source of truth for gRPC service definitions consumed by `platform-edge`, `platform-identity`, `platform-core`, `platform-domain`, and other services.

## Structure

```
platform-contracts/
├── proto/              # Protobuf definitions (source of truth)
│   ├── accesscontrol/  # Platform-level roles and permissions
│   ├── feedback/       # Feedback service
│   ├── featureregistry/  # Feature catalog and tenant-scoped resolution
│   ├── framework/      # Career paths, competencies, rubrics
│   ├── goals/          # Goals service
│   ├── identity/       # Identity and auth
│   ├── oneonone/       # 1:1 meeting management
│   ├── orgcontext/     # Organisation context
│   ├── pdp/            # Personal Development Plan
│   ├── preferences/    # User preferences
│   ├── profile/        # Employee profiles
│   ├── settings/       # Settings service (legacy; see tenantconfig)
│   ├── shared/         # Shared types and common definitions
│   ├── surveys/        # Survey campaigns
│   ├── tenant/         # Tenant CRUD and membership
│   └── tenantconfig/   # Tenant config, navigation, notices
├── gen/                # Generated code (Go)
│   └── go/             # Go protobuf and gRPC stubs
├── buf.yaml            # Buf module configuration
├── buf.gen.yaml        # Code generation configuration
└── Makefile            # generate, lint, breaking, verify targets
```

## Prerequisites

- [buf](https://buf.build/docs/installation) CLI
- Go 1.25+

## Quick Start

```bash
# Generate Go code from proto definitions
make generate
# or: buf generate

# Lint proto files
make lint
# or: buf lint

# Check for breaking changes (against main)
make breaking
# or: buf breaking --against '.git#branch=main'

# Verify generated code is up to date
make verify
```

## Development Workflow

### Adding New Proto Files

1. Create `.proto` files under `proto/<domain>/v1/`
2. Follow existing package naming: `peoplesuite/platform-contracts/gen/go/<domain>/v1;<domain>v1`
3. Run `make generate` and commit generated code
4. Run `make lint` and fix any issues

### Updating Existing Protos

1. Edit the `.proto` files
2. Run `make breaking` to ensure no breaking changes
3. Run `make generate` and update generated code
4. Run `make lint`

### Code Generation

```bash
make generate
# or: buf generate
```

Generates Go protobuf and gRPC code into `gen/go/` using the plugins defined in `buf.gen.yaml`.

### Linting

```bash
make lint
# or: buf lint
```

Validates proto files against the `STANDARD` rule set.

### Breaking Changes

```bash
make breaking
# or: buf breaking --against '.git#branch=main'
```

Detects breaking API changes. Run this before merging proto changes to avoid breaking consumers.

## CI

On push and pull request to `main`/`master`, the workflow runs:

- **test**: buf lint, buf breaking (PRs only), buf generate, verify `gen/` and `go.mod`, `go build ./...`
- **lint**: golangci-lint
- **tag** (push only): auto-increments and pushes patch version tag
- **release** (when tag pushed): creates GitHub release

## Integration

Other PeopleSuite services consume these contracts by:

1. **Go modules**: Add `peoplesuite/platform-contracts` as a dependency and import from `peoplesuite/platform-contracts/gen/go/<domain>/v1`
2. **Buf dependencies**: Reference this module via buf's dependency management (if using buf in consuming repos)

## Contributing

- Keep proto changes backward-compatible when possible
- Run `make lint` and `make breaking` before opening a PR
- Ensure generated code is committed with proto changes
- Use `v1` package versioning for new domains; introduce `v2` only when breaking changes are required
