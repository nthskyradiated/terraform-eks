## AWS EKS deployment Terraform template:

* Initialize the project: 
```bash
terraform init
```
* Run terraform apply:
```bash
terraform apply --auto-approve
```

* To set your eks profile context:
```bash
aws eks update-kubeconfig --region your-region --name your-eks-cluster-name

* To switch to a different eks profile:
```bash
aws eks update-kubeconfig --region your-region --name your-eks-cluster-name --profile your-other-profile
```
* To check if k8s service account has admin access, run:
```bash
kubectl auth can-i "*" "*"
```
* To get specific EKS add-on version using AWS cli run:
```bash
# Getting pod-identity-agent version as example

aws eks describe-addon-versions --addon-nameeks-pod-identity-agent --kubernetes-version 1.32
```