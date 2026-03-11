.PHONY: generate lint breaking clean verify deps help

# Default target
help:
	@echo "Platform Contracts - Available targets:"
	@echo "  make generate  - Run buf generate to produce Go code"
	@echo "  make lint      - Run buf lint to validate proto files"
	@echo "  make breaking  - Check for breaking changes against main"
	@echo "  make clean     - Remove generated code in gen/"
	@echo "  make verify    - Verify generated code matches committed code"
	@echo "  make deps      - Update buf dependencies"
	@echo "  make help      - Show this help"

generate:
	buf generate

lint:
	buf lint

breaking:
	buf breaking --against '.git#branch=main'

clean:
	rm -rf gen/go/*

verify: generate
	@git diff --exit-code gen/ || (echo "Generated code is out of date. Run 'make generate' and commit the changes." && exit 1)

deps:
	buf dep update
