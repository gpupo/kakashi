#!/bin/bash
APP_PATH="$(dirname $0)";
source $APP_PATH/build-functions.sh;

compileBin flood-monitor;

chmod +x bin/*.sh;
