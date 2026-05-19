# AWS Account Inventory

## Account map

| Alias                      | Account ID     | Email                                          | Purpose / Notes                   |
|----------------------------|---------------|------------------------------------------------|-----------------------------------|
| org-management             | 111111111111  | aws.example+management@yourdomain.com          | Root / Management account         |
| audit                      | 222222222222  | aws.example+audit@yourdomain.com               | Audit & compliance logging        |
| security                   | 333333333333  | aws.example+security@yourdomain.com            | SecurityHub, GuardDuty, Config    |
| network                    | 444444444444  | aws.example+network@yourdomain.com             | Transit Gateway, VPC, networking  |
| shared                     | 555555555555  | aws.example+shared@yourdomain.com              | ECR, ACM, Route 53, SSO           |
| myapp-region1-production   | 666666666661  | aws.example+region1-prod@yourdomain.com        | Production — Region 1 workloads   |
| myapp-region2-development  | 777777777771  | aws.example+region2-dev@yourdomain.com         | Development — Region 2 workloads  |



## Mandatory pre-command check

ALWAYS run `aws sts get-caller-identity --profile {profile}` before any
destructive operation. Never assume which account the default profile points to.

## Production accounts — extra caution required

The following accounts contain production workloads. Any destructive Terraform
or CLI operation requires peer review before execution:
- `myapp-region1-production` → 666666666661
- `myapp-region2-sit`        → 777777777774  (SIT = shared integration, treat as prod)

## Forbidden operations (require explicit approval)
- Deleting AWS Organizations SCPs
- Removing accounts from OUs
- Disabling CloudTrail in any account
- Any action in `org-management` (111111111111) — management/root account
- Modifying `security` (333333333333) account controls
