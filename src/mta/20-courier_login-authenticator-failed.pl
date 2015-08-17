
    #courier_login-authenticator-failed
    if (($lgfile eq $config{CUSTOM8_LOG}) and ($line =~ /^[a-zA-Z0-9:=().-\s]{2,}courier_login authenticator failed for\s+[\S\s]{2,}\[(\S+)\]:\d+:\s+\d+\sIncorrect authentication data\s+\S+/)) {
      return ("Kakashi knocked a bad guy",$1,"kakashi-courier_login-authenticator-failed","5","","0");
    }
