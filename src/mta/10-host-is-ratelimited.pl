	#host-is-ratelimited
	if (($lgfile eq $config{CUSTOM8_LOG}) and ($line =~ /^[a-zA-Z0-9:=().-\s]{2,}\[(\S+)\]:[a-zA-Z0-9=<\-@.>\"\s]{2,}:\s"+Host is ratelimited\s+[\S\s]{2,}/)) {
		return ("Kakashi knocked other opponent",$1,"kakashi-host-is-ratelimited","3","","0");
	}
