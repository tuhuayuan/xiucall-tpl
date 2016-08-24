# Short name: Short name, following [a-zA-Z_], used all over the place.
# Some uses for short name:
# - Docker image name
# - Kubernetes service, rc, pod, secret, volume names
SHORT_NAME := xiucall-admin

include includes.mk versioning.mk

# Kubernetes-specific information for Secret, RC, Service, and Image.
Deployment := manifests/${SHORT_NAME}-deployment.yaml
Service := manifests/${SHORT_NAME}-service.yaml

all:
	@echo "Use a Makefile to control top-level building of the project."

# For cases where we're building from local
# We also alter the RC file to set the image name.
docker-build: check-docker 
	docker build --rm -t ${IMAGE} rootfs
	docker tag ${IMAGE} ${MUTABLE_IMAGE}

# Push to a registry that Kubernetes can access.
docker-push: check-docker docker-build
	docker push ${IMAGE}

# Deploy is a Kubernetes-oriented target
deploy: set-images kube-service kube-deployment

# Some things, like services, have to be deployed before pods. This is an
# example target. Others could perhaps include kube-volume, etc.
kube-service: check-kubectl
	kubectl create -f ${Service}

# When possible, we deploy with RCs.
kube-deployment: check-kubectl
	kubectl create -f ${Deployment}

kube-clean: check-kubectl
	kubectl delete -f ${Service}
	kubectl delete -f ${Deployment}

set-images:
	sed 's#\(image:\) .*#\1 $(IMAGE)#' manifests/${SHORT_NAME}-deployment.yaml.tpl \
		> ${Deployment}

.PHONY: all deploy
