# Github Actions complete DevOps CI/CD Pipeline Project Architecture (NodeJS Application)
![CompleteCICDProject!](https://raw.githubusercontent.com/bryanmartineze/gh-devops-project/main/cicd-pipeline-example.jpg)

# Github Actions complete DevOps CI/CD Pipeline Project Setup

1) Fork this GitHub Repository `gh-devops-project` and clone the code of this branch(main) to 
    your remote repository. 
    - Clone the Repository in the "Repository" directory/folder in your local
    - Add the code to git, commit and push it to your upstream branch "main or master"
    - Confirm that the code exist on GitHub

2) Setup you on AWS Account, and create a role Terraform to use OIDC auth to deploy Infrastructure:




2) Create a Terraform Cloud account:
    - Go to https://app.terraform.io/session and create a Terraform Cloud account
    - Create a new organization
    - Create a project named "Terraform"
    - Create 2 workspaces: "cicd-pipeline-example-prod" and "cicd-pipeline-example-test"
    - Select run projects through API-driven Workflow
    - Go to User Settings > Tokens > Create an API Token, please store this Token in a safe location
    - Replace the account name provide inside of terraform-prod/main.tf and terraform-test/main.tf with the name of your organization (instead of bryanmartineze-devops).
    - Inside of each workspace, define the variables as desired: aws_account_id, aws_eks_admin1_arn, aws_eks_admin2_arn, aws_region, customer_hosted_zone, TFC_AWS_PROVIDER_AUTH and TFC_AWS_RUN_ROLE_ARN

## Running the app

It is not necessary to run this app locally in order to complete the learning activities, but if you wish to do so you will need a local installation of npm. Begin by installing the npm dependencies with:

    npm install

Then, you can run the app with:

    npm start

Once it is running, you can access it in a browser at [http://localhost:8080](http://localhost:8080)

# Create access to Terraform Cloud using OIDC

# Dockerfile

Container should be running as docker run -d -p 8080:3000 test/trainschedule
