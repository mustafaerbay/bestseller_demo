# Requierements

Launch a webserver on an EC2 instance with the following config:

- [ ] Must be allowed to read files from an S3 bucket you’ve created.

- [ ] Inside an autoscaling group with scaling policies:

  - scale-in: CPU utilization > 80%
  - scale-out: CPU utilization < 60%
  - minimum number of instances = 1
  - maximum number of instances = 3

- [ ] Inside a private subnet

- [ ] Under a public load balancer

- [ ] Install a webserver (Apache, NGINX, etc) through bootstrapping

- [ ] The webserver should be accessible only through the load balancer


### Expectations

- Use Terraform (from 0.13 onwards)

- Provide clear instructions on how to execute your code so that it can be deployed by anyone.

- Working index.html for the webserver. It could be as simple as a Hello World .
