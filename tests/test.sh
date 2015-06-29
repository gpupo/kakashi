#!/bin/bash
#
# This file is part of gpupo/kakashi
# https://github.com/gpupo/kakashi
#
# (c) Gilmar Pupo <g@g1mr.com>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.

while read -r line
do
    perl $1 "$line";
done <  $2;
