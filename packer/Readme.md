###Build ami for deployment

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
