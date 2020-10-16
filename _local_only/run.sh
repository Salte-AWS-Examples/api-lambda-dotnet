#!/bin/bash

# Ensures that any deployments from the command line include an updated commit tied to any changes that have been made and are being applied.
COMMAND=$(echo "$1" | tr '[:upper:]' '[:lower:]')
# COMMITTED=$(git status | grep "nothing to commit, working tree clean")
# if [ -z "$COMMITTED" ]; then
#   if ([ "$COMMAND" != "validate" ] && [ "$COMMAND" != "graph" ]); then
#     echo "Since you haven't committed your code the current command will be overridden with \"validate\"."
#     COMMAND=validate
#   fi
# fi

# Validate Inputs
if [ -z "$COMMAND" ] || ([ "$COMMAND" != "apply" ] &&  [ "$COMMAND" != "destroy" ] && [ "$COMMAND" != "validate" ] && [ "$COMMAND" != "graph" ]); then
  echo "You must pass one of the following arguments to this script: apply, destroy, validate."
  exit 1
fi

# Setup Environment
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
if [ -f "$DIR/env.sh" ]; then
  . $DIR/env.sh
fi

# Set the Terraform workspace to the current deployable branch or default to sandbox.
BRANCH=$(git rev-parse --abbrev-ref HEAD | grep -P "(sandbox|development|qa|production)")
if [ -z "$BRANCH" ]; then
  BRANCH=sandbox
fi

cd $DIR/../src/api_lambda_dotnet

dotnet restore

ret=$?
if [ $ret -ne 0 ]; then
  echo "The restore must have failed! The return code was ${ret}."
  return $ret
fi

cd $DIR/../test/api_lambda_dotnet.Tests

dotnet test

ret=$?
if [ $ret -ne 0 ]; then
  echo "One or more test must have failed! The return code was ${ret}."
  return $ret
fi

cd $DIR/../src/api_lambda_dotnet

dotnet build -c Release

ret=$?
if [ $ret -ne 0 ]; then
  echo "The build must have failed! The return code was ${ret}."
  return $ret
fi

cd $DIR/../terraform

# terraform init -input=false -backend-config="bucket=${BUCKET}" -backend-config="key=${KEY}" -backend-config="region=${AWS_DEFAULT_REGION}" -backend-config="dynamodb_table=terraform-statelock" -backend-config="encrypt=true" -backend-config="kms_key_id=${KMS_KEY}" -backend-config="role_arn=${BACKEND_ROLE}"
terraform init

# terraform workspace select $BRANCH || terraform workspace new $BRANCH

terraform $COMMAND
