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

### Software Requirements

- kubectl
- helm
- minikube

### Setup

Create minikube cluster (including grafana, prometheus, and traefik)

```bash
make minikube
```

### Cleanup

Delete minikube cluster

```bash
make cleanup
```
