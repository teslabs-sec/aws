# VM-Series with AWS GWLB Demo Guide

## Overview

This code helps deploy all the resources required to successfully demonstrate the VM-Series reference architecture with the AWS Gateway Load Balancer. This deployment Post the successful deployment of the resources, including the Palo Alto Networks VM-Series Next Generation Firewall, you will be able to secure all Inbound, Outbound and East traffic to the 2 spoke servers also deployed as part of the demonstration.

## Pre-requisites

- Permissions to subscribe to VM-Series on the AWS Marketplace.
- Permissions to deploy all networking resources like VPC, Subnets, etc.
- Permissions to deploy EC2 instances and connect to them via SSH.

## Demo Lab Setup

In this section, we will launch the lab environment. These are the steps that we will accomplish at this time.

- Login to the AWS Console using the provided credentials and set up IAM roles
- Subscribe to the Palo Alto Networks VM-Series PAYG on the AWS Marketplace.
   - You can follow this link to open the Marketplace page directly. On the page that opens up, Click on “Continue to Subscribe” and then Click on “Accept Terms”.<br/>https://aws.amazon.com/marketplace/pp?sku=hd44w1chf26uv4p52cdynb2o
- Deploy lab environment using Terraform

#### Deploying from local workspace

If you are attempting to deploy from your local workspace, you would need to update the below values on the _utd-aws-vm-series/terraform/vmseries/student.auto.tfvars_ file.

```
access-key      = ""
secret-key      = ""
region          = ""
ssh-key-name    = ""
```

In case you are using AWS CloudShell, you can ignore this step. 

### Run the setup

Once you have completed the above steps as required, ensure that you are in the root directory of the cloned repo and run the below command.

```
./setup.sh
```

It will take around 5 minutes to deploy all the lab components. Status will be updated on the cloudshell console as deployment progresses. At the end of deployment, you should see the message “Completed successfully!”

## Demo Lab Teardown

Ensure that you have the permissions to delete all the resources that were created as part of the setup. Adjust the "cd" command below to change the directory as required.
Run the below commands to teardown the setup.

```
cd utd-aws-vm-series/terraform/vmseries
terraform destroy -auto-approve
```
