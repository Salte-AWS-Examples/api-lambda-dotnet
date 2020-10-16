#!/bin/bash

###############################################################################
# 1. Copy this file to env.sh.
# 2. Populate the AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN,
#    and TF_VAR_CI_PROJECT_PATH_SLUG values.
# 3. Populate the TF_VAR_SALT_CONFIGURATION_REPOSITORY value.
# 4. Run ./_local_only/run.sh validate|apply|destroy from the project root.
#
# *** NOTE: ANY ACTION TAKEN WILL AFFECT THE BRANCH YOU ARE CURRENTLY ON ***
###############################################################################

export AWS_DEFAULT_REGION=us-east-1
# Credentials must be able to assume the role specified in both the backend configuration file (i.e. backend.tf) and the role specified in the main.tf AWS provisioner.
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_SESSION_TOKEN=

# Inputs defined in the root inputs.tf file.
export TF_VAR_assume_role_arn=arn:aws:iam::853196007801:role/GitlabRunnerRole
export TF_VAR_CI_COMMIT_SHORT_SHA=$(git rev-parse --short HEAD)
export TF_VAR_CI_JOB_ID=00000
export TF_VAR_CI_PROJECT_PATH_SLUG=api_lambda_dotnet
