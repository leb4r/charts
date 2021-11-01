# charts

Collection of Helm Charts.

## Security

This project has not be audited for security vulnerabilities by a third-party. Use at your own discretion.

## Usage

Add the Chart repository

```bash
helm repo add leb4r https://leb4r.github.io/charts
```

## Development

## Software Requirements

- kubectl
- helm
- minikube

## Setup

Create minikube luster

```bash
bash scripts/setup-minikube.sh
```

Install tools (grafana, prometheus, and traefik)

```bash
bash scripts/setup-cluster.sh
```
