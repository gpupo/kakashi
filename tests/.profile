#!/bin/bash
# Usage: include into you env:
# source .profile;
#

kakashi-test-create() { touch ./tests/dataprovider/${1}.txt; touch ./tests/regex/${1}.pl;}
kakashi-test() { ./tests/test.sh ./tests/regex/${1}.pl ./tests/dataprovider/${1}.txt; }
