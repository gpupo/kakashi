#!/usr/bin/perl

$line = $ARGV[0];

# http-client-suspect
# Watch http clients
if ($line =~ /^(\S+)\s+-[\s\/[\]:-\d+A-z".]{2,}\s+HTTP\/1.\d"\s\d+\s\d+\s"-"\s"Ruby"$/)  {
    printf "[$1] Match!\n";
} else {
    print "\nFail:${line}\n";
}
