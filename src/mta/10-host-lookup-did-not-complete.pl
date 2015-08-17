
	#host-lookup-did-not-complete
	if (($lgfile eq $config{CUSTOM8_LOG}) and ($line =~ /^[a-zA-Z0-9:=().-\s]{2,}\[(\S+)\]:[a-zA-Z0-9=<\-@.>\s]{2,}:\s+host lookup did not complete/)) {
		return ("Kakashi knocked his opponent",$1,"kakashi-host-lookup-did-not-complete","2","","0");
	}
