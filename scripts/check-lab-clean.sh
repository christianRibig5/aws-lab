#!/bin/bash

REGION="ca-central-1"

echo "===================================="
echo " AWS LAB CLEANUP CHECK - $REGION"
echo "===================================="

echo ""
echo "1. EKS Clusters"
aws eks list-clusters --region $REGION

echo ""
echo "2. EC2 Running Instances"
aws ec2 describe-instances \
  --region $REGION \
  --filters "Name=instance-state-name,Values=running,pending,stopping,stopped" \
  --query "Reservations[].Instances[].{ID:InstanceId,State:State.Name,Type:InstanceType,Name:Tags[?Key=='Name'].Value|[0]}" \
  --output table

echo ""
echo "3. RDS Databases"
aws rds describe-db-instances \
  --region $REGION \
  --query "DBInstances[].{DB:DBInstanceIdentifier,Status:DBInstanceStatus,Engine:Engine}" \
  --output table

echo ""
echo "4. NAT Gateways"
aws ec2 describe-nat-gateways \
  --region $REGION \
  --query "NatGateways[].{ID:NatGatewayId,State:State,Vpc:VpcId}" \
  --output table

echo ""
echo "5. Load Balancers"
aws elbv2 describe-load-balancers \
  --region $REGION \
  --query "LoadBalancers[].{Name:LoadBalancerName,Type:Type,State:State.Code,DNS:DNSName}" \
  --output table

echo ""
echo "6. EBS Volumes not deleted"
aws ec2 describe-volumes \
  --region $REGION \
  --query "Volumes[].{ID:VolumeId,State:State,Size:Size,Type:VolumeType,Name:Tags[?Key=='Name'].Value|[0]}" \
  --output table

echo ""
echo "7. Elastic IPs"
aws ec2 describe-addresses \
  --region $REGION \
  --query "Addresses[].{PublicIP:PublicIp,AllocationId:AllocationId,Associated:AssociationId}" \
  --output table

echo ""
echo "8. VPCs"
aws ec2 describe-vpcs \
  --region $REGION \
  --query "Vpcs[].{VpcId:VpcId,Default:IsDefault,CIDR:CidrBlock}" \
  --output table

echo ""
echo "9. Subnets"
aws ec2 describe-subnets \
  --region $REGION \
  --query "Subnets[].{SubnetId:SubnetId,VpcId:VpcId,CIDR:CidrBlock,AZ:AvailabilityZone}" \
  --output table

echo ""
echo "10. Internet Gateways"
aws ec2 describe-internet-gateways \
  --region $REGION \
  --query "InternetGateways[].{IGW:InternetGatewayId,VPC:Attachments[0].VpcId,State:Attachments[0].State}" \
  --output table

echo ""
echo "11. Security Groups excluding default"
aws ec2 describe-security-groups \
  --region $REGION \
  --query "SecurityGroups[?GroupName!='default'].{ID:GroupId,Name:GroupName,Vpc:VpcId}" \
  --output table

echo ""
echo "12. CloudWatch Log Groups related to EKS/Lambda"
aws logs describe-log-groups \
  --region $REGION \
  --query "logGroups[?contains(logGroupName, 'eks') || contains(logGroupName, 'lambda') || contains(logGroupName, 'catalog')].{Name:logGroupName,StoredBytes:storedBytes}" \
  --output table

echo ""
echo "13. Secrets Manager Secrets"
aws secretsmanager list-secrets \
  --region $REGION \
  --query "SecretList[].{Name:Name,Status:DeletedDate}" \
  --output table

echo ""
echo "14. IAM Roles likely created for lab"
aws iam list-roles \
  --query "Roles[?contains(RoleName, 'eks') || contains(RoleName, 'EKS') || contains(RoleName, 'catalog') || contains(RoleName, 'pod') || contains(RoleName, 'lambda')].{RoleName:RoleName,Created:CreateDate}" \
  --output table

echo ""
echo "15. IAM Policies likely created for lab"
aws iam list-policies --scope Local \
  --query "Policies[?contains(PolicyName, 'eks') || contains(PolicyName, 'EKS') || contains(PolicyName, 'catalog') || contains(PolicyName, 'pod') || contains(PolicyName, 'lambda')].{PolicyName:PolicyName,Arn:Arn}" \
  --output table

echo ""
echo "===================================="
echo " CHECK COMPLETE"
echo " If tables are empty, your lab is mostly clean."
echo " Pay special attention to NAT Gateway, RDS, EC2, Load Balancer, EBS, and Elastic IP."
echo "===================================="