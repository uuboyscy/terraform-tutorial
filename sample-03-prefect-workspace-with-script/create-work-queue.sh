#!/bin/bash

PREFECT_CLI=$1

$PREFECT_CLI -p dev work-queue ls

