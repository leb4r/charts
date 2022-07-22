#!/bin/bash

# see https://github.com/kubernetes/minikube/issues/7923#issuecomment-920018825

readonly KUBERNETES_VERSION="stable"
readonly MINIKUBE_ARGS="--feature-gates=LocalStorageCapacityIsolation=false"

readonly -a MINIKUBE_ADDONS=(
	"metrics-server"
)

function _minikube_check() {
	command -v minikube 2>/dev/null
}

function _delete_minikube_cluster() {
	minikube delete
}

# start the cluster with a given kubernetes version
function _start_minikube_cluster() {
	local version="${1:-"stable"}" args=$2

	minikube start \
		--kubernetes-version=$version \
		$args
}

# make sure certain addons are available
function _enable_minikube_addons() {
	local addons=$@
	minikube addons enable ${addons[*]}
}

## CLI handlers

function handle_delete() {
	_delete_minikube_cluster
}

function handle_start() {
	_start_minikube_cluster $KUBERNETES_VERSION $MINIKUBE_ARGS
	_enable_minikube_addons $MINIKUBE_ADDONS
}

function parse_args() {
	while [[ $1 ]]; do
		echo "Handling [$1]..."
		case "$1" in
		--all)
			handle_delete
			handle_start
			shift
			break
			;;
		--delete)
			handle_delete
			shift
			break
			;;
		--start)
			handle_start
			shift
			break
			;;
		*)
			echo "Error: Unknown option: $1" >&2
			exit 1
			;;
		esac
	done
}

function main() {
	if _minikube_check; then
		parse_args $@
	fi
}

main $@
