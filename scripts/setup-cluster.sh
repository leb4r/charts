#!/bin/bash

PROMETHEUS_CHART="prometheus-community/prometheus"
GRAFANA_CHART="grafana/grafana"
TRAEFIK_CHART="traefik/traefik"

MONITORING_NAMESPACE="monitoring"
INGRESS_NAMESPACE="ingress"

# dir of script
_dir=$(dirname $0)

# default k8s client
_kube="kubectl"

if command -v kubectl >/dev/null 2>&1; then
	_kube="$_kube"
elif command -v minikube >/dev/null 2>&1; then
	_kube="minikube kubectl"
else
	echo "kubectl or minikube is not installed..."
	echo "cannot continue..."
	exit 1
fi

if ! $_kube get namespace $MONITORING_NAMESPACE; then
	$_kube create namespace $MONITORING_NAMESPACE
fi

if ! $_kube get namespace $INGRESS_NAMESPACE; then
	$_kube create namespace $INGRESS_NAMESPACE
fi

if command -v helm 2>/dev/null; then
	helm repo add traefik https://helm.traefik.io/traefik
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo add grafana https://grafana.github.io/helm-charts
	helm repo update

	helm install -n $INGRESS_NAMESPACE traefik $TRAEFIK_CHART --values $_dir/values/traefik.yaml || true
	helm install -n $MONITORING_NAMESPACE prometheus $PROMETHEUS_CHART --values $_dir/values/prometheus.yaml || true
	helm install -n $MONITORING_NAMESPACE grafana $GRAFANA_CHART --values $_dir/values/grafana.yaml || true
else
	echo "helm is not installed..."
	echo "cannot continue setting up cluster..."
	exit 1
fi
