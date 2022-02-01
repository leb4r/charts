.PHONY: cleanup docs index lint minikube test

cleanup:
	bash scripts/setup-minikube.sh --delete

docs:
	bash .github/helm-docs.sh

index:
	cr index --pr --owner leb4r --git-repo charts --charts-repo https://leb4r.github.io/charts

lint:
	ct lint --all

minikube:
	bash scripts/setup-minikube.sh --start
	bash scripts/setup-cluster.sh

test:
	ct install --config ct.yaml
