#!/bin/bash
# This file is part of gpupo/kakashi
# https://opensource.gpupo.com/kakashi
#
# (c) Gilmar Pupo <contact@gpupo.com>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.

while read -r line
do
    perl $1 "$line";
done <  $2;
