    # could-not-complete-sender-verify
    if (($lgfile eq $config{CUSTOM8_LOG}) and ($line =~ /^[a-zA-Z0-9:=().-\s]{2,}\[(\S+)\]:[a-zA-Z0-9=<\-@.>\s]{2,}:\s+Could not complete sender verify/)) {
    	return ("Kakashi knocked a ghost server",$1,"kakashi-could-not-complete-sender-verify","2","","0");
    }
