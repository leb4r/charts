.PHONY: docs index lint

docs:
	bash .github/helm-docs.sh

index:
	cr index --pr --owner leb4r --git-repo charts --charts-repo https://leb4r.github.io/charts

lint:
	ct lint --all
