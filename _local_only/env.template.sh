#!/bin/bash

###############################################################################
# 1. Copy this file to env.sh.
# 2. Populate the AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN,
#    and TF_VAR_CI_PROJECT_PATH_SLUG values.
# 3. Populate the TF_VAR_SALT_CONFIGURATION_REPOSITORY value.
# 4. Run ./_local_only/run.sh validate|apply|plan|destroy|validate|graph from
#    the project root.
###############################################################################

# Variables Required by the AWS Provider
export AWS_DEFAULT_REGION=
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=

# Inputs Defined in the Root inputs.tf File
export TF_VAR_assume_role_arn=arn:aws:iam::[Account Number]:role/[Role Name]
export TF_VAR_CI_COMMIT_SHORT_SHA=$(git rev-parse --short HEAD)
export TF_VAR_CI_JOB_ID=00000
export TF_VAR_CI_PROJECT_PATH_SLUG=salte-aws-examples-api-lambda-dotnet

# Variables Required by the run.sh Script
export SONARQUBE_URL=
export SONARQUBE_TOKEN=
