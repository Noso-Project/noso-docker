WORKDIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

NOSO_VERSION ?= v0.2.1F

REPO := ghcr.io/noso-project
APP := noso-node
IMAGE := $(REPO)/$(APP):$(NOSO_VERSION)

REVISION := $(shell git rev-parse --short=8 HEAD)
TAG := $(shell git describe --tags --exact-match $(REVISION) 2>/dev/null)

build:
	$(info # #########################################################)
	$(info #)
	$(info # Building $(IMAGE))
	$(info #)
	$(info # #########################################################)
	docker build -t $(IMAGE) --build-arg NOSO_VERSION=$(NOSO_VERSION) .

push:
	$(info # #########################################################)
	$(info #)
	$(info # Pushing $(IMAGE) to GHCR)
	$(info #)
	$(info # #########################################################)
	docker push $(IMAGE)

run:
	$(info # #########################################################)
	$(info #)
	$(info # Starting $(IMAGE))
	$(info #)
	$(info # #########################################################)
	docker run --rm -it \
		--name $(APP) \
		--mount source=NOSODATA,target=/app/NOSODATA \
		$(IMAGE)
exec:
	$(info # #########################################################)
	$(info #)
	$(info # Exec-ing into $(IMAGE))
	$(info #)
	$(info # #########################################################)
	docker exec -it $(APP) bash

shell:
	$(info # #########################################################)
	$(info #)
	$(info # Starting $(IMAGE) with bash shell)
	$(info #)
	$(info # #########################################################)
	docker run --rm -it \
		--entrypoint bash \
		--name $(APP) \
		--mount source=NOSODATA,target=/app/NOSODATA \
		$(IMAGE)

stop:
	$(info # #########################################################)
	$(info #)
	$(info # Stopping $(IMAGE))
	$(info #)
	$(info # #########################################################)
	docker stop $(APP)
