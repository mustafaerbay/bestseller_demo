### Preconditions

[Install Packer](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli)

[Install AWSCLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)


### Configure AWS credentials
Packer and Terraform need to the AWS credentials so You need to export the keys below or you can use the aws CLI tool to configure credentials

```
aws configure 
```

```
$ export AWS_ACCESS_KEY_ID="anaccesskey"
$ export AWS_SECRET_ACCESS_KEY="asecretkey"
$ export AWS_DEFAULT_REGION="us-west-2"
$ terraform plan
```

### Packer 
For aws EC2 instance, we need to build our own ami with packer to install awscli and nginx on top of the ubuntu image


Go to "packer" directory and run below commands
```
packer validate aws-ubuntu.pkr.hcl
```
```
packer build aws-ubuntu.pkr.hcl
```
Then get ami-id and use it as an input parameter of terraform.

```
terraform plan -var="ami=ami-XXXXXXXXXX" -out=plan
```
```
terraform apply "plan"
```