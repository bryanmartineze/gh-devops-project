# cicd-pipeline-train-schedule-gradle

This is a simple train schedule app written using nodejs. It is intended to be used as a sample application for a series of hands-on learning activities.

# Install gradle

wget https://services.gradle.org/distributions/gradle-8.2.1-bin.zip

mkdir /opt/gradle

unzip -d /opt/gradle ~/gradle-8.2.1-bin.zip

sudo vi /etc/profile.d/gradle.sh

export PATH=$PATH:/opt/gradle/gradle-8.2.1/bin

sudo chmod 755 /etc/profile.d/gradle.sh


## Running the app

It is not necessary to run this app locally in order to complete the learning activities, but if you wish to do so you will need a local installation of npm. Begin by installing the npm dependencies with:

    npm install

Then, you can run the app with:

    npm start

Once it is running, you can access it in a browser at [http://localhost:3000](http://localhost:3000)

# Create access to Terraform Cloud using OIDC

# Dockerfile

Container should be running as docker run -d -p 8080:3000 test/trainschedule