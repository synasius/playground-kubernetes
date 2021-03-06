OS_TYPE := linux

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
	OS_TYPE := darwin
endif

KUBERNETES_RELEASE := $(shell curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)

KOPS_VERSION ?= 1.7.0
KOPS_URL := https://github.com/kubernetes/kops/releases/download/$(KOPS_VERSION)/kops-$(OS_TYPE)-amd64

KUBECTL_URL := https://storage.googleapis.com/kubernetes-release/release/$(KUBERNETES_RELEASE)/bin/$(OS_TYPE)/amd64/kubectl

HELM_VERSION ?= v2.6.0
HELM_URL := https://kubernetes-helm.storage.googleapis.com/helm-$(HELM_VERSION)-$(OS_TYPE)-amd64.tar.gz


BINDIR := $(CURDIR)/bin
INSTALL_PREFIX ?= $(HOME)/.local/bin


.PHONY: all
all: kops kubectl helm deis iam


.PHONY: kops
kops:
	@echo "Install kops"
	@mkdir -p $(BINDIR)
	curl -LO $(KOPS_URL)
	mv kops-$(OS_TYPE)-amd64 $(BINDIR)/kops
	chmod +x $(BINDIR)/kops

.PHONY: iam
iam:
	@echo "Download script to create IAM user"
	curl -LO https://raw.githubusercontent.com/kubernetes/kops/master/hack/new-iam-user.sh
	chmod +x ./new-iam-user.sh

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

.PHONY: install
install:
	@echo "Install binaries in ${INSTALL_PREFIX}"
	cp -r $(BINDIR)/* $(INSTALL_PREFIX)
