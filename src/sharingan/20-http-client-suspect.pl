
    # http-client-suspect: Watch http clients
    if (($lgfile eq $config{CUSTOM7_LOG}) and ($line =~ /^(\S+)\s+-[\s\/[\]:-\d+A-z".]{2,}\s+HTTP\/1.\d"\s\d+\s\d+\s"-"\s"Ruby"$/)) {
      return ("Kakashi [sharingan] knocked a bad browser",$1,"kakashi-sharingan-http-client-suspect","30","80,443","0");
    }
