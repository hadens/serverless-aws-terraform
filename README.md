# serverless-aws-terraform
This repository contains code to deploy a "Hello World" serverless application along with an API Endpoint to invoke the application.

I will be using AWS Lambda and API Gateway for the application backend and will be using Terraform to automate all infrastructure provisioning.

I created this for a personal challenge and used it as a learning opportunity. Hopefully this will be helpful for anyone in need of an example to work off. Pull requests are welcome.


## Usage

### Requirements
- Terraform 0.12.X
- AWS Access

### Instructions
- `terraform init`
- `terraform plan`
- `terraform apply`


### Inputs
| Name                   | Description                                  | Type     | Default                                     | Required |
| ---------------------- | -------------------------------------------- | -------- | ------------------------------------------- | :------: |
| region                 | Region to deploy in                          | `string` | `"us-west-2"`                               |   yes    |
| lambda\_function\_code | Lambda function deployment package file path | `string` | `"./modules/lambda/hello-world-lambda.zip"` |   yes    |

**Note:** A majority of inputs have been omitted, such as parameters for the Lambda function name, IAM role names, etc. These are located in `variables.tf`. 

### Outputs
| Name               | Description                                                   |
| ------------------ | ------------------------------------------------------------- |
| api\_endpoint\_url | API Endpoint URL that can be invoked to query the application |