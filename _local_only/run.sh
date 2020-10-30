#!/bin/bash

# #############################################################################
# Validate Inputs
# #############################################################################
COMMAND=$(echo "$1" | tr '[:upper:]' '[:lower:]')
if [ -z "$COMMAND" ] || ([ "$COMMAND" != "apply" ] &&  [ "$COMMAND" != "plan" ] &&  [ "$COMMAND" != "destroy" ] && [ "$COMMAND" != "validate" ] && [ "$COMMAND" != "graph" ]); then
  echo "You must pass one of the following arguments to this script: apply, destroy, validate."
  exit 1
fi

# #############################################################################
# Setup Environment
# #############################################################################
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
if [ -f "$DIR/env.sh" ]; then
  . $DIR/env.sh
fi

if [ "$COMMAND" = "apply" ] ||  [ "$COMMAND" = "plan" ]; then
  # ###########################################################################
  # Run Unit Tests w/ Coverage and Send Code and Coverage Report to Sonarqube
  # ###########################################################################
  cd $DIR/../src/api_lambda_dotnet
  export AWS_XRAY_CONTEXT_MISSING=LOG_ERROR
  dotnet sonarscanner begin /k:"api_lambda_dot_net" /d:sonar.login=$SONARQUBE_TOKEN /d:sonar.host.url=$SONARQUBE_URL /d:sonar.cs.opencover.reportsPaths="../../test/api_lambda_dotnet.Tests/coverage.opencover.xml"
  dotnet build
  dotnet test ../../test/api_lambda_dotnet.Tests /p:CollectCoverage=true /p:CoverletOutputFormat=opencover
  dotnet sonarscanner end /d:sonar.login=$SONARQUBE_TOKEN

  ret=$?
  if [ $ret -ne 0 ]; then
    echo "One or more tests must have failed! The return code was ${ret}."
    exit $ret
  fi

  # ###########################################################################
  # Build Project and Prepare for Deployment via Terraform
  # ###########################################################################
  dotnet publish -c Release

  ret=$?
  if [ $ret -ne 0 ]; then
    echo "The build must have failed! The return code was ${ret}."
    exit $ret
  fi
fi

# #############################################################################
# Initialize Terraform and Execute Specified Command
# #############################################################################
cd $DIR/../terraform
terraform init
terraform $COMMAND
