#!/bin/bash

PREFECT_CLI=$1
PREFECT_VERSION=$($PREFECT_CLI version)
echo "$PREFECT_VERSION"
echo "test"
