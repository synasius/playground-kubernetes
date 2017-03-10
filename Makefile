OS_TYPE := linux

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
	OS_TYPE := darwin
endif

KUBERNETES_RELEASE := $(shell curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)

KOPS_VERSION ?= 1.5.3
KOPS_URL := https://github.com/kubernetes/kops/releases/download/$(KOPS_VERSION)/kops-$(OS_TYPE)-amd64

KUBECTL_URL := https://storage.googleapis.com/kubernetes-release/release/$(KUBERNETES_RELEASE)/bin/$(OS_TYPE)/amd64/kubectl

HELM_VERSION ?= v2.2.2
HELM_URL := https://kubernetes-helm.storage.googleapis.com/helm-$(HELM_VERSION)-$(OS_TYPE)-amd64.tar.gz


BINDIR := $(CURDIR)/bin


.PHONY: kops
kops:
	@echo "Install kops"
	@mkdir -p $(BINDIR)
	curl -LO $(KOPS_URL)
	mv kops-$(OS_TYPE)-amd64 $(BINDIR)/kops
	chmod +x $(BINDIR)/kops

.PHONY: kubectl
kubectl:
	@echo "Install kubectl"
	@echo "Latest Kubernetes release is ${KUBERNETES_RELEASE}"
	curl -LO $(KUBECTL_URL)
	mv kubectl $(BINDIR)/kubectl
	chmod +x $(BINDIR)/kubectl

.PHONY: helm
helm:
	@echo "Install helm"
	curl -LO $(HELM_URL)
	tar -xvf helm-$(HELM_VERSION)-$(OS_TYPE)-amd64.tar.gz --strip-components=1 --no-anchored helm
	mv helm $(BINDIR)/helm
	chmod +x $(BINDIR)/helm
	rm helm-$(HELM_VERSION)-$(OS_TYPE)-amd64.tar.gz

.PHONY: deis
deis:
	@echo "Install deis"
	curl -sSL http://deis.io/deis-cli/install-v2.sh | bash
	mv deis $(BINDIR)/deis
