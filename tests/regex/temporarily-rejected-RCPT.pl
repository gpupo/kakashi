#!/usr/bin/perl

$line = $ARGV[0];

if ($line =~ /^\S+\s+\S+\s+H=\S+\s+\[(\S+)\]:\d+\s+F=\S+\s+temporarily rejected RCPT\s+\S+\s+Could not complete sender verify/) {
    #print ".";
} else {
    print "\nNo Match:${line}\n";
}
