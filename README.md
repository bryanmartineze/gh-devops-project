# Github Actions complete DevOps CI/CD Pipeline Project Architecture (NodeJS Application)
![CompleteCICDProject!](https://raw.githubusercontent.com/bryanmartineze/gh-devops-project/main/cicd-pipeline-example.jpg)

# Github Actions complete DevOps CI/CD Pipeline Project Setup

1) Fork this GitHub Repository `gh-devops-project` and clone the code of this branch(main) to 
    your remote repository. 
    - Clone the Repository in the "Repository" directory/folder in your local
    - Add the code to git, commit and push it to your upstream branch "main or master"
    - Confirm that the code exist on GitHub

2) Setup you on AWS Account, and create a role Terraform to use OIDC auth to deploy Infrastructure:
   - Go to IAM and create a Role with Custom Truth Policy
   - Follow this guide https://vimalpaliwal.medium.com/securing-authentication-between-terraform-cloud-and-aws-using-oidc-67c2de31ec89
   - Grant AdministratorAccess in order to grant power to create whatever resources are needed for this Pipeline

3) Create a Terraform Cloud account:
    - Go to https://app.terraform.io/session and create a Terraform Cloud account
    - Create a new organization
    - Create a project named "Terraform"
    - Create 2 workspaces: "cicd-pipeline-example-prod" and "cicd-pipeline-example-test"
    - Select run projects through API-driven Workflow
    - Go to User Settings > Tokens > Create an API Token, please store this Token in a safe location
    - Replace the account name provide inside of terraform-prod/main.tf and terraform-test/main.tf with the name of your organization (instead of bryanmartineze-devops).
    - Inside of each workspace, define the variables as desired: aws_account_id, aws_eks_admin1_arn, aws_region, customer_hosted_zone, TFC_AWS_PROVIDER_AUTH and TFC_AWS_RUN_ROLE_ARN

4) Create a Slack Channel and create a chat bot application:
   - Go to https://slack.com/ and create a new workspace.
   - Add the chat:write bot scope under OAuth & Permissions.
   - Install the app to your workspace.
   - Copy the app's Bot Token from the OAuth & Permissions page and add it as a secret in your repo settings named SLACK_BOT_TOKEN.
   - Invite the bot user into the channel you wish to post messages to (/invite @bot_user_name).

5) Create a Slack Channel and create a chat bot application:
   - Go to https://slack.com/ and create a new workspace.
   - Add the chat:write bot scope under OAuth & Permissions.
   - Install the app to your workspace.
   - Copy the app's Bot Token from the OAuth & Permissions page and add it as a secret in your repo settings named SLACK_BOT_TOKEN.
   - Invite the bot user into the channel you wish to post messages to (/invite @bot_user_name).
   - Define a new enviroment variable in github actions with the name of CHANNEL_ID.

6) Create a dockerhub account to push into a public registry:
   - Go to https://hub.docker.com/ and create an account.


7) Create Secrets inside the Github Actions Workflow:
    - AWS_ACCOUNT_ID
    - AWS_REGION
    - AWS_ACCESS_KEY_ID (For eks admin)
    - AWS_SECRET_ACCESS_KEY (For eks admin)
    - DOCKER_PASSWORD
    - DOCKER_USER
    - GRAFANA_PASSWORD
    - SLACK_BOT_TOKEN (Instructions last step)
    - TF_API_TOKEN

8) Create a Route53 public domain:
   - It is necessary in order to make the external-dns work (see more at https://github.com/kubernetes-sigs/external-dns) in my case, I named it swodevops.net

## Running the app

It is not necessary to run this app locally in order to complete the steps, but if you wish to do so you will need a local installation of npm. Begin by installing the npm dependencies with:

    npm install

Then, you can run the app with:

    npm start

Once it is running, you can access it in a browser at [http://localhost:8080](http://localhost:8080)

# Dockerfile

Container should be running as docker run -d -p 80:8080 <YOUR_REPO/YOUR_IMAGE>
