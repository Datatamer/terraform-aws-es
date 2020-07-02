# Terraform Module Template
This is an AWS ES domain github repo, to create an ES domain on AWS.

# Examples
## Basic
Inline example implementation of the module.  This is the most basic example of what it would look like to use this module.
```
module "tamr-es-cluster" {
  source = "git::https://github.com/Datatamer/terraform-aws-es?ref=0.1.0"
  aws_account_id = "123456789"
}
```
## Minimal
Smallest complete fully working example. This example might require extra resources to run the example.
- [Minimal](https://github.com/Datatamer/terraform-template-repo/tree/master/examples/minimal)

# Resources Created
This modules creates:
* a new Elasticsearch domain in AWS
* optionally, a new IAM service linked role for ES on the AWS account

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_account\_id | AWS account ID to use | `string` | n/a | yes |
| additional\_tags | Additional tags to be attached to the ES domain | `map(string)` | <pre>{<br>  "Author": "Tamr"<br>}</pre> | no |
| aws\_region | AWS region to launch in | `string` | `"us-east-1"` | no |
| create\_new\_service\_role | Whether to create a new IAM service linked role for ES. This only needs to happen once per account | `bool` | `true` | no |
| domain\_name | The name to give to the ES domain | `string` | `"tamr-es-cluster"` | no |
| ebs\_enabled | Whether EBS volumes are attached to data nodes | `bool` | `true` | no |
| ebs\_iops | The baseline I/O performance of EBS volumes attached to nodes | `number` | `0` | no |
| ebs\_volume\_size | The size of EBS volumes attached to data nodes (in GB) | `number` | `10` | no |
| ebs\_volume\_type | The type of EBS volumes attached to data nodes | `string` | `"gp2"` | no |
| es\_version | Version of ES to deploy | `string` | `"6.8"` | no |
| instance\_count | Number of instances to launch in the ES domain | `number` | `2` | no |
| instance\_type | Instance type of data nodes in the domain | `string` | `"c5.large.elasticsearch"` | no |
| security\_group\_ids | List of security group IDs to be applied to the ES domain | `list(string)` | `[]` | no |
| snapshot\_start\_hour | Hour when an automated daily snapshot of the indices is taken | `number` | `0` | no |
| subnet\_ids | List of subnet IDs for the ES domain to be created in | `list(string)` | `[]` | no |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

# References
This repo is based on:
* [terraform standard module structure](https://www.terraform.io/docs/modules/index.html#standard-module-structure)
* [templated terraform module](https://github.com/tmknom/template-terraform-module)

# Development
## Generating Docs
Run `make gen` to generate the section of docs around terraform inputs, outputs and requirements.

## Checkstyles
Run `make lint`, this will run terraform fmt, in addition to a few other checks to detect whitespace issues.
NOTE: this requires having docker working on the machine running the test

## Releasing new versions
* Update version contained in `VERSION`
* Document changes in `CHANGELOG.md`
* Create a tag in github for the commit associated with the version

# License
Apache 2 Licensed. See LICENSE for full details.
