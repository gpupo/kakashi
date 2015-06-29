$line = $ARGV[0];

# http-login-failed
# Watch http login fail with http status code 401 or 241(custom error code with bypass error pages override on mod_proxy)
if ($line =~ /^(\S+)\s+-[\s\/[\]:-\d+A-z".]{2,}\s+HTTP\/1.\d"\s+((\b401\b)|(\b241\b))\s+\d+\s+[\S ]{2,}/)  {
    printf "[$1] Match!\n";
} else {
    print "\nFail:${line}\n";
}
