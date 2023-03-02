#!/bin/bash
set -e
for i in `aws elbv2 describe-target-health --target-group-arn arn:aws:elasticloadbalancing:ap-south-1:453374638244:targetgroup/first/a70c06970a2ac65f --query 'TargetHealthDescriptions[*].Target.Id' --output text`
do
aws elbv2 deregister-targets --target-group-arn arn:aws:elasticloadbalancing:ap-south-1:453374638244:targetgroup/first/a70c06970a2ac65f --targets Id=$i 
echo "[server]" > /etc/ansible/hosts
aws ec2 describe-instances --instance-ids $i |jq -r '.Reservations[].Instances[].PrivateIpAddress' >> /etc/ansible/hosts
ansible-playbook -e 'host_key_chaking=False' ansible.yaml --private-key=/home/key/nodeuser.pem -u nodeuser --ssh-common-args='-o StrictHostKeyChecking=no'
sleep 330
aws elbv2 register-targets --target-group-arn arn:aws:elasticloadbalancing:ap-south-1:453374638244:targetgroup/first/a70c06970a2ac65f --targets Id=$i
done
