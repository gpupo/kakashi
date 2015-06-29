#!/usr/bin/perl
# absurd-spamscore
# IP block on mail server detected a message with a spam score integer greater or equal to 90

$line = $ARGV[0];

if ($line =~ /^[a-zA-Z0-9:=().-\s]{2,}\[(\S+)\]:[a-zA-Z0-9=<\-@.>\s]{2,}:\s+"[a-zA-Z0-9=<\-@.>()[\]\s]{2,}:\d+\sbecause mail server detected a message with a spam score integer greater or equal to\s\d+"/) {
    printf "Match!";
} else {
    printf "\nFail:${line}\n";
}
