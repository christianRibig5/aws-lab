# AWS Reusable DevOps Lab

A reusable AWS infrastructure lab for DevOps, Platform Engineering, SRE, and Cloud Infrastructure practice.

The lab is designed to provide a reusable Kubernetes platform that can support multiple application projects without rebuilding cluster-wide infrastructure for every project.

The main goals are:

- Provision AWS infrastructure with Terraform
- Orchestrate the complete lifecycle with Ansible
- Run Kubernetes workloads on Amazon EKS
- Use EKS Pod Identity for AWS permissions
- Install reusable cluster-wide add-ons
- Keep application-specific resources outside the platform repository
- Destroy costly AWS resources when testing is complete
- Preserve Terraform remote state for fast future rebuilds

---

## Architecture

```text
Bootstrap
   ↓
VPC
   ↓
EKS
   ↓
Kubeconfig
   ↓
EKS Pod Identity Agent
   ↓
EBS CSI Driver
   ↓
Secrets Store CSI Driver
   ↓
AWS Secrets & Configuration Provider (ASCP)
   ↓
AWS Load Balancer Controller IAM / Pod Identity
   ↓
AWS Load Balancer Controller
   ↓
Reusable Kubernetes Platform Ready

The lab acts as a shared platform.

Application projects consume the platform instead of recreating cluster-wide infrastructure.

Technology Stack:

Infrastructure as Code

Terraform
AWS
Amazon EKS
Amazon VPC
IAM
S3 Remote State

Configuration and Orchestration:

Ansible

Kubernetes Platform:

Kubernetes
Helm
EKS Pod Identity
EBS CSI Driver
Secrets Store CSI Driver
AWS Secrets & Configuration Provider
AWS Load Balancer Controller

AWS Services:

Amazon EKS
Amazon EC2
Amazon VPC
Amazon EBS
AWS IAM
Amazon S3
AWS Secrets Manager
Elastic Load Balancing

Repository Structure:

aws-lab/
├── .gitignore
├── README.md
│
├── ansible/
│   ├── ansible.cfg
│   ├── group_vars/
│   │   └── all.yml
│   ├── inventory/
│   │   └── localhost.yml
│   ├── playbooks/
│   │   ├── lab-up.yml
│   │   └── lab-down.yml
│   └── roles/
│       ├── terraform/
│       ├── eks_kubeconfig/
│       ├── secrets_store_csi/
│       ├── secrets_store_csi_uninstall/
│       ├── ascp/
│       ├── ascp_uninstall/
│       ├── aws_load_balancer_controller/
│       └── aws_load_balancer_controller_uninstall/
│
├── bootstrap/
│   ├── c1-versions.tf
│   ├── c2-variables.tf
│   ├── c3-s3bucket.tf
│   └── c4-output.tf
│
├── config/
│
├── scripts/
│   └── check-lab-clean.sh
│
└── terraform/
    ├── vpc/
    ├── eks/
    ├── ecr-repos/
    ├── github-oidc/
    ├── secrets-manager/
    └── eks-addons/
        ├── pod-identity-agent/
        ├── ebs-csi/
        └── aws-load-balancer-controller/
            ├── c1-versions.tf
            ├── c2-variables.tf
            ├── c3-remote-state.tf
            ├── c4-iam.tf
            ├── c5-service-account.tf
            ├── c6-pod-identity.tf
            ├── c7-outputs.tf
            └── policies/
                └── aws-load-balancer-controller-permission-policy.json
Platform vs Application Responsibilities

The repository intentionally separates reusable platform infrastructure from project-specific resources.

aws-lab owns
VPC
Public and private subnets
NAT Gateway
Internet Gateway
EKS cluster
EKS node groups
EKS Pod Identity Agent
EBS CSI Driver
Secrets Store CSI Driver
AWS Secrets & Configuration Provider
AWS Load Balancer Controller
Cluster-wide IAM and Pod Identity requirements
Terraform remote state infrastructure
Application repositories own
Application source code
Dockerfiles
CI/CD pipelines
ECR repositories
Application-specific IAM roles
GitHub OIDC configuration
Kubernetes namespaces
Deployments
Services
Ingress resources
Application secrets
SecretProviderClass
GitOps manifests
Monitoring dashboards specific to the application

This prevents the base lab from becoming tightly coupled to a single application.

Terraform State

Terraform remote state is stored in Amazon S3.

Current backend bucket:

tfstate-dev-ca-central-1-i1zfl3al

Example state layout:

vpc/dev/terraform.tfstate

eks/dev/terraform.tfstate

eks-addons/ebs-csi/dev/terraform.tfstate

eks-addons/aws-load-balancer-controller/dev/terraform.tfstate

The bootstrap Terraform configuration creates the persistent S3 state bucket.

Bootstrap resources are intentionally excluded from the normal lab destruction process.

Prerequisites

Install the following tools before using the lab:

AWS CLI
Terraform
Ansible
kubectl
Helm
Git

Authenticate to AWS using the configured CLI profile:

aws sso login --profile dev-admin

Verify authentication:

aws sts get-caller-identity --profile dev-admin
Provision the Lab

Move to the Ansible directory:

cd ansible

Validate the playbook:

ansible-playbook playbooks/lab-up.yml --syntax-check

Review execution order:

ansible-playbook playbooks/lab-up.yml --list-tasks

Provision the complete platform:

ansible-playbook playbooks/lab-up.yml \
  -e "lab_action=apply"
Lab Provisioning Order

Ansible orchestrates Terraform and Helm in the required dependency order.

1. VPC
2. EKS
3. Configure kubectl
4. EKS Pod Identity Agent
5. EBS CSI Driver
6. Secrets Store CSI Driver
7. AWS Secrets & Configuration Provider
8. AWS Load Balancer Controller IAM / Pod Identity
9. AWS Load Balancer Controller Helm installation
Destroy the Lab

The lab is designed to be destroyed after testing to reduce AWS cost.

Run:

ansible-playbook playbooks/lab-down.yml

The playbook requires manual confirmation:

DESTROY

The destruction flow runs in reverse dependency order.

AWS Load Balancer Controller Helm
        ↓
AWS Load Balancer Controller Terraform
        ↓
ASCP
        ↓
Secrets Store CSI Driver
        ↓
EBS CSI Driver
        ↓
EKS Pod Identity Agent
        ↓
EKS
        ↓
VPC

Bootstrap and Terraform remote state remain available.

Cleanup Verification

After destroying the lab, run:

./scripts/check-lab-clean.sh

The cleanup script checks for resources that may continue generating AWS charges, including:

EKS clusters
EC2 instances
RDS databases
NAT Gateways
Load Balancers
EBS volumes
Elastic IP addresses
VPCs
Subnets
Internet Gateways
Security Groups
CloudWatch log groups
Secrets Manager secrets
IAM roles
IAM policies

Default AWS networking resources are expected to remain.

EKS Pod Identity

The lab uses EKS Pod Identity instead of embedding AWS credentials in Kubernetes workloads.

The general authentication flow is:

Kubernetes Pod
     ↓
Kubernetes Service Account
     ↓
EKS Pod Identity Association
     ↓
IAM Role
     ↓
AWS Permissions

Current platform components using Pod Identity include:

EBS CSI Driver
AWS Load Balancer Controller

Application projects can create their own Pod Identity associations when application workloads need AWS permissions.

Secrets Management

The lab installs:

Secrets Store CSI Driver
        +
AWS Secrets & Configuration Provider

Application projects can then retrieve secrets from AWS Secrets Manager through Kubernetes.

Example flow:

AWS Secrets Manager
        ↓
ASCP
        ↓
Secrets Store CSI Driver
        ↓
SecretProviderClass
        ↓
Application Pod

The SecretProviderClass remains project-specific and should live in the application repository.

Storage

Amazon EBS CSI Driver provides persistent block storage for Kubernetes workloads.

The driver is managed as an EKS add-on and uses:

EKS Pod Identity
        ↓
ebs-csi-controller-sa
        ↓
AmazonEBSCSIDriverPolicy

Application workloads can request storage using Kubernetes PersistentVolumeClaims.

Load Balancing

The AWS Load Balancer Controller is installed using Helm.

Terraform manages:

IAM role
IAM policy
IAM role-policy attachment
Kubernetes service account
EKS Pod Identity Association

Ansible and Helm manage the controller installation.

Application repositories define their own Kubernetes Ingress resources.

Example flow:

Application Ingress
        ↓
AWS Load Balancer Controller
        ↓
Application Load Balancer
        ↓
Target Group
        ↓
Kubernetes Service
        ↓
Application Pods
Cost Management

This lab is intentionally designed for temporary development and testing.

Cost-sensitive resources include:

EKS control plane
EC2 worker nodes
NAT Gateway
Load Balancers
EBS volumes
CloudWatch logs

Destroy the lab when it is not being used:

ansible-playbook playbooks/lab-down.yml

The remote Terraform state remains available for future recreation.

Recommended Development Workflow

For each application project:

1. Bring up aws-lab
        ↓
2. Verify EKS and cluster add-ons
        ↓
3. Provision project-specific AWS resources
        ↓
4. Deploy application workloads
        ↓
5. Test CI/CD and GitOps
        ↓
6. Validate ingress, secrets, storage and monitoring
        ↓
7. Remove project workloads
        ↓
8. Destroy aws-lab
Git Security

The repository must not contain:

AWS access keys
passwords
Terraform state files
.env files containing secrets
kubeconfig credentials
private keys
secret Terraform variable files

Terraform lock files should remain committed:

.terraform.lock.hcl

Remote state should remain in S3 rather than Git.

Current Environment
AWS Region: ca-central-1
Environment: dev
AWS CLI Profile: dev-admin
EKS Cluster: retail-dev-eksjalexsol
Future Improvements

Possible future additions include:

Reusable project deployment Ansible roles
Argo CD bootstrap
Prometheus
Grafana
Loki
Alertmanager
External DNS
Cert Manager
Centralized logging
Policy enforcement
Kubernetes security hardening
Automated platform health checks
Application onboarding templates

These should only be promoted into the base platform when they are genuinely reusable across projects.

Purpose

This repository is primarily a practical Platform Engineering and DevOps lab.

It demonstrates:

Infrastructure as Code
Configuration management
Infrastructure orchestration
Kubernetes platform engineering
Cloud cost management
IAM and workload identity
Reusable platform design
Separation between platform and application ownership
Repeatable provisioning and destruction

The overall design goal is:

Build the platform once, reuse it across projects, and destroy costly infrastructure when it is not needed.