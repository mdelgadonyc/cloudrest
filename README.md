# CloudRest 

CloudRest is a serverless API implemented on AWS using Terraform and making use of DynamoDB to store data.


## Table of Contents

- [Installation](#Installation)
- [Usage](#Usage)
- [Contributing](#Contributing)
- [License](#License)

## Installation

To install CloudRest locally:

1. ### Clone this repository

2. ### Install aws-cli
    $ `pip install awscli --upgrade --user`  

3. ### Install Terraform
   $ `sudo apt install terraform`
   
    Note: Excellent instructions for installing Terraform on Ubuntu available at:
    [https://computingforgeeks.com/how-to-install-terraform-on-ubuntu/](https://computingforgeeks.com/how-to-install-terraform-on-ubuntu/)

## Usage

1. ### Login to AWS Account Using AWS CLI
    $ `aws configure`  
    $ `terraform init`  
    $ `terraform apply`  

    Note: Excellent instructions for setting up the AWS portion available at: 
    [https://linuxhint.com/install_aws_cli_ubuntu/](https://linuxhint.com/install_aws_cli_ubuntu/)

## Contributing

Please open an issue to suggest fixes or ideas for improving CloudRest.

## License

[The GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.en.html)
