#!/bin/bash
#
while read -r line
do
    perl $1 "$line";
done <  $2;
