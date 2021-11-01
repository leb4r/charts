#!/bin/bash

# see https://github.com/kubernetes/minikube/issues/7923#issuecomment-920018825

KUBERNETES_VERSION="stable"
MINIKUBE_ARGS="--feature-gates=LocalStorageCapacityIsolation=false"

if ! command -v minikube 2>/dev/null; then
	echo "minikube is not installed..."
	exit 1
fi

minikube delete
minikube start \
	--kubernetes-version=$KUBERNETES_VERSION \
	$MINIKUBE_ARGS

# make sure certain addons are available
minikube addons enable metrics-server
