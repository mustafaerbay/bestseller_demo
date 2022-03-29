###Build ami for deployment


packer validate aws-ubuntu.pkr.hcl

packer build aws-ubuntu.pkr.hcl
