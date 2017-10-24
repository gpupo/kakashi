#!/bin/bash
## This file is part of gpupo/kakashi
# https://opensource.gpupo.com/kakashi
#
# (c) Gilmar Pupo <contact@gpupo.com>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#
# Usage: include into you env:
# source .profile;


kakashi-test-create() { touch ./tests/dataprovider/${1}.txt; touch ./tests/regex/${1}.pl;}
kakashi-test() { ./tests/test.sh ./tests/regex/${1}.pl ./tests/dataprovider/${1}.txt; }
