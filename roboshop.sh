#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-0caef3e699037dfa4"

for instance in $@
do
    INSTANCE_ID=$(aws ec2 run-instances --image-id ami-09c813fb71547fc4f --instance-type t3.micro --security-group-ids sg-0caef3e699037dfa4 --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=$instances}]' --query 'Instances[0].InstanceId' --output text)
    #Get Private IP
    if [ $instance != "frontend" ]; then
        IP=$(aws ec2 describe-instances --instance-ids i-0a22587c910cc2cbf --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text)
    else
        IP=$(aws ec2 describe-instances --instance-ids i-0a22587c910cc2cbf --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
    fi

    echo "$instance: $IP"
done