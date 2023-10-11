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
    $ `pip3 install awscli --upgrade --user`  

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

2. ### Use an API platform like [Postman](https://www.postman.com/downloads/) to set and get data via the endpoint returned by Terraform  
   #### Set data via POST request  
       Use Postman to submit a Post request to the URL and endpoint returned by Terraform (ie. https://kfd5dbmxqf.execute-api.us-east-1.amazonaws.com/py-lambda-stage/pet)  
       With the data as JSON in the body (i.e. {"id": "1", "name": "Spot", "breed": "chihuahua", "gender": "male", "owner": "Hector Ortiz", "birthday": "05112020"} )  

   #### Retrieve data via GET request   
       Use Postman to submit a Get request to the URL and endpoint returned by Terraform, and the id number of the stored data item appended at the end
       (ie. https://kfd5dbmxqf.execute-api.us-east-1.amazonaws.com/py-lambda-stage/pet?id=1)


https://github.com/mdelgadonyc/cloudrest/assets/17136771/5b7b8643-2c3e-4a5e-8d4e-4e1eb1405d0b



## Contributing

Please open an issue to suggest fixes or ideas for improving CloudRest.

## License

[The GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.en.html)
