## AWS EKS deployment Terraform template:

* Initialize the project: 
```bash
terraform init
```
* Run terraform apply:
```bash
terraform apply --auto-approve
```

* To update your kubeconfig context:
```bash
aws eks update-kubeconfig --region your-region --name your-eks-cluster-name
```
* To get specific EKS add-on version using AWS cli run:
```bash
# Getting pod-identity-agent version as example

aws eks describe-addon-versions --addon-nameeks-pod-identity-agent --kubernetes-version 1.32
```