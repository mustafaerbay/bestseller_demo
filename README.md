### Architecture

![Alt text](/screenshots/bestseller.drawio.png?raw=true "solution")

According to the requirements, basically I need to have an EC2 instance working in the private network and connected with S3 bucket. AWS provides VPC endpoints to connect ec2 instance behind private network with S3 buckets. The other way is to route network traffice through NAT Gateway on public subnet. In this solution VPC endpoints used. And besides that I had to serve index.html with bootstrapped Nginx. So I decided to put index.html into the S3 bucket and get it from there during the deployment.

Also I decided to create my own ami to use based on ubuntu-18.04 and initial bootstap configurations has been done in packer build part.

As an output of packer build command you have ami-XXXXXXXX to use it as an variable of ami.


Conclusion:
To connect EC2 instance to the S3 bucket VPC endpoints has been used.
nginx bootstrap has been done in with packer
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
packer validate \
-var 'region=us-west-2' \
-var 'instance_type=t2.micro' \
-var 'tag=bestseller' \
-var 'environment=prod' \
aws-ubuntu.pkr.hcl
```
```
packer build \
-var 'region=us-west-2' \
-var 'instance_type=t2.micro' \
-var 'tag=bestseller' \
-var 'environment=prod' \
aws-ubuntu.pkr.hcl
```
Then get ami-id and use it as an input parameter of terraform.

![Alt text](screenshots/Screen%20Shot%202022-03-30%20at%2015.44.38.png?raw=true "packer build")


### Terraform

To initialize infrastructure run below command;

```
terraform plan \
-var="instance_ami=ami-0e25a85626e298436" \
-var="region=us-west-2" \
-var="tag=bestseller" \
-var="instance_type=t2.micro" \
-var="environment=prod" \
-out=plan
```
![Alt text](screenshots/Screen%20Shot%202022-03-30%20at%2015.48.39.png?raw=true "solution")

```
terraform apply "plan"
```

![Alt text](screenshots/Screen%20Shot%202022-03-30%20at%2015.52.44.png?raw=true "solution")

To destroy :

```
terraform plan -destroy \
-var="instance_ami=ami-0e25a85626e298436" \
-var="region=us-west-2" \
-var="tag=bestseller" \
-var="instance_type=t2.micro" \
-var="environment=prod" \
-out=plan
```
