# Platform Contracts

Centralized protobuf contracts and API definitions for the PeopleSuite platform. This repository is the single source of truth for gRPC service definitions consumed by `platform-domain`, `identity-facade`, `ess-portal-bff`, and other services.

## Structure

```
platform-contracts/
├── proto/           # Protobuf definitions (source of truth)
│   ├── feedback/    # Feedback service
│   ├── framework/   # Career paths, competencies, rubrics
│   ├── goals/       # Goals service
│   ├── identity/    # Identity and auth
│   ├── oneonone/    # 1:1 meeting management
│   ├── orgcontext/  # Organisation context
│   ├── pdp/         # Personal Development Plan
│   ├── preferences/ # User preferences
│   ├── profile/     # Employee profiles
│   ├── settings/    # Settings service
│   ├── shared/      # Shared types and common definitions
│   └── surveys/     # Survey campaigns
├── gen/             # Generated code (Go)
│   └── go/          # Go protobuf and gRPC stubs
├── graphql/         # GraphQL schemas (future)
├── jsonschema/      # JSON Schema definitions (future)
├── openapi/         # OpenAPI specs (future)
├── events/          # Event definitions (future)
├── buf.yaml         # Buf module configuration
└── buf.gen.yaml     # Code generation configuration
```

## Prerequisites

- [buf](https://buf.build/docs/installation) CLI
- Go 1.25+

## Quick Start

```bash
# Generate Go code from proto definitions
buf generate

# Lint proto files
buf lint

# Check for breaking changes (against main)
buf breaking --against '.git#branch=main'
```

## Development Workflow

### Adding New Proto Files

1. Create `.proto` files under `proto/<domain>/v1/`
2. Follow existing package naming: `peoplesuite/platform-contracts/gen/go/<domain>/v1;<domain>v1`
3. Run `buf generate` and commit generated code
4. Run `buf lint` and fix any issues

### Updating Existing Protos

1. Edit the `.proto` files
2. Run `buf breaking --against '.git#branch=main'` to ensure no breaking changes
3. Run `buf generate` and update generated code
4. Run `buf lint`

### Code Generation

```bash
buf generate
```

Generates Go protobuf and gRPC code into `gen/go/` using the plugins defined in `buf.gen.yaml`.

### Linting

```bash
buf lint
```

Validates proto files against the `STANDARD` rule set.

### Breaking Changes

```bash
buf breaking --against '.git#branch=main'
```

Detects breaking API changes. Run this before merging proto changes to avoid breaking consumers.

## Integration

Other PeopleSuite services consume these contracts by:

1. **Go modules**: Add `peoplesuite/platform-contracts` as a dependency and import from `peoplesuite/platform-contracts/gen/go/<domain>/v1`
2. **Buf dependencies**: Reference this module via buf's dependency management (if using buf in consuming repos)

## Contributing

- Keep proto changes backward-compatible when possible
- Run `buf lint` and `buf breaking` before opening a PR
- Ensure generated code is committed with proto changes
- Use `v1` package versioning for new domains; introduce `v2` only when breaking changes are required
