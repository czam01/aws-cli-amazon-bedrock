# EKS Cluster Inventory

All clusters are in region: **us-east-1 (N. Virginia)**
Replace region, cluster names, account IDs, and profiles with your real values.

## Cluster map

| Context alias | Cluster name              | Account ID     | Account alias              | AWS Profile                | Environment |
|---------------|---------------------------|---------------|----------------------------|---------------------------|-------------|
| `dev`         | myapp-dev-eks-cluster     | 777777777771  | myapp-region2-development  | EKSDeployment_dev         | development |
| `sit`        | myapp-sit-eks-cluster    | 777777777774  | myapp-region2-sit          | EKSDeployment_sit         | sit         |
| `prod1`       | myapp-prod1-eks-cluster   | 666666666661  | myapp-region1-production   | EKSDeployment_prod        | production  |

## Clusters by environment

### Development
```
dev   -> myapp-dev-eks-cluster   (777777777771) profile: EKSDeployment_dev
dev1  -> myapp-dev1-eks-cluster  (777777777771) profile: EKSDeployment_dev
```

### SIT (System Integration Test) — treat as near-prod
```
sit1 -> myapp-sit-eks-cluster (777777777774) profile: EKSDeployment_sit
```

```

### Production — extra caution required
```
prod1 -> myapp-prod-eks-cluster (666666666661) profile: EKSDeployment_prod
```

---

## kubeconfig update commands

```bash
# Development clusters
aws eks update-kubeconfig --name myapp-dev-eks-cluster  --region us-east-1 --profile EKSDeployment_dev --alias dev

# SIT cluster
aws eks update-kubeconfig --name myapp-sit-eks-cluster --region us-east-1 --profile EKSDeployment_sit --alias sit

#  UAT clusters
aws eks update-kubeconfig --name myapp-uat-eks-cluster --region us-east-1 --profile EKSDeployment_uat --alias uat

# Production cluster — verify account before running
aws sts get-caller-identity --profile EKSDeployment_prod  # confirm account 666666666661
aws eks update-kubeconfig --name myapp-prod-eks-cluster --region us-east-1 --profile EKSDeployment_prod --alias prod
```

---

## Context switching

```bash
# List all available contexts
kubectl config get-contexts

# Switch context by alias
kubectl config use-context dev
kubectl config use-context prod1

# Recommended: use kubectx for faster switching
kubectx dev
kubectx prod
```

---

## Upgrade policy

- Never upgrade production without validating in sit1 and uat1 first
- Node groups are updated AFTER the control plane is healthy and verified
- No production upgrades on Fridays or before a holiday

## Production cluster — mandatory pre-operation checklist

Before ANY operation on `prod1` (myapp-prod-eks-cluster, account 666666666661):
1. `aws sts get-caller-identity --profile EKSDeployment_prod` — verify correct account
2. `kubectl config current-context` — confirm context = `prod`
