#!/usr/bin/perl

$line = $ARGV[0];

if ($line =~ /^\S+\s+\S+\s+H=\[(\S+)\]:\d+\s+temporarily rejected connection in\s+\S+\s+\S+\s+\S+Host is ratelimited\s\S+\s+\S+/)  {
    print "Match!\n";
} else {
    print "No Match\n";
}
