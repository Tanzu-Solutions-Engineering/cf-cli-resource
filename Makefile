.PHONY: bleeding default

.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

bleeding: ## Build a cf-cli-resource image containing bleeding edge cf-cli binary
	go get github.com/cloudfoundry/cli; \
	wd=$$(pwd); \
	cd $${GOPATH}/src/github.com/cloudfoundry/cli; \
	BUILD_VERSION=$$(cat ci/VERSION); \
	BUILD_SHA=$$(git rev-parse --short HEAD); \
	BUILD_DATE=$$(date -u +"%Y-%m-%d"); \
	VERSION_LDFLAGS="-X code.cloudfoundry.org/cli/version.binaryVersion=$${BUILD_VERSION} -X code.cloudfoundry.org/cli/version.binarySHA=$${BUILD_SHA} -X code.cloudfoundry.org/cli/version.binaryBuildDate=$${BUILD_DATE}"; \
	CGO_ENABLED=$${CGO_ENABLED:-0} GOARCH=$${GOARCH:-amd64} GOOS=$${GOOS:-linux} go build -a -tags netgo -installsuffix netgo -ldflags "-w -s -extldflags \"-static\" $${VERSION_LDFLAGS}" -o $${wd}/cf; \
	cd $${wd}; \
	docker build -f Dockerfile.bleeding -t paasmule/cf-cli-resource:bleeding .

default: ## Build an image with static cf-cli binary in it
	docker build -t paasmule/cf-cli-resource .
