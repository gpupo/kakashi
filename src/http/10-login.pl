
    # http-login-failed: watch http login fail with http status code 401 or 241(custom error code with bypass error pages override on mod_proxy)
    if (($lgfile eq $config{CUSTOM7_LOG}) and ($line =~ /^(\S+)\s+-[\s\/[\]:-\d+A-z".]{2,}\s+HTTP\/1.\d"\s+((\b401\b)|(\b241\b))\s+\d+\s+[\S ]{2,}/)) {
      return ("Kakashi knocked a housebreaker",$1,"kakashi-http-login-failed","15","80,443","0");
    }
