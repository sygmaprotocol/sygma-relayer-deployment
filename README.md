# Chaibridge Hub Deployment

## Setup AWS account

If you already don't own an AWS Account, use [this link as a guide from the official support](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/)

## How to run infrastructure provisioning first time

#### Tools

To create the resources in our repository you're going to need:
- [AWS CLI 2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Terraform > 1.0](https://learn.hashicorp.com/tutorials/terraform/install-cli)

Now we can proceed to the resources in our AWS Account.

Before you run the Terraform Scripts, make sure to set the right Environment Variables to access your account. You might need an user with the right privileges to create the resources.

#### VPC

The only requirement to create the Relayers infrastructure is a VPC. Of course you can use the default VPC from any region in your AWS account, but it's a best practice to create a VPC to allocate your resources. If you don't know what a VPC is, [use this document to better understand it](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html).

In this repository, we have the folder `terraform/vpc`. In that folder run the following commands:
```
terraform init
terraform apply
```

You might need to input a few variables, you can do that in the prompt that will appear in your terminal or you could create a file called `terraform.tfvars` with the desired values. [Read this link for more information on Input Variables](https://www.terraform.io/language/values/variables).

When the prompt appears to apply the changes, type `yes`.

More details on how to run Terraform [what this video](https://learn.hashicorp.com/tutorials/terraform/aws-build?in=terraform/aws-get-started).

#### ECS

In this repository, we have the folder `terraform/relayers`. In that folder run the following commands:
```
terraform init
terraform apply
```

You might need to input a few variables, you can do that in the prompt that will appear in your terminal or you could create a file called `terraform.tfvars` with the desired values. [Read this link for more information on Input Variables](https://www.terraform.io/language/values/variables).

When the prompt appears to apply the changes, type `yes`.


## How to run relayer configuration script

The configuration for the relayers is in the folder `ecs`. For ECS we configure our applications with a Task Definition. [You can read more about it here](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definitions.html).

You can create any number of relayers. For each one, you're going to need a Task Definition.

## How to use AWS SSM to setup private vatiables (Private key, api keys, etc)

We use SSM to hold all of our secrets. To access it, go to your AWS Account, in the Search bar type `SSM`. Go into the Systems Manager Service. On the left side menu, go into Parameter Store.
Now you can create any secrets that you want, and then reference it in the `secrets` section in the Task Definition.

## How to update relayer

We use Github Actions to update our relayers. We provided an example under `.github/workflows/`. Make sure to grant all necessary permissions to the pipeline, either using IAM Roles or Environment Variables.