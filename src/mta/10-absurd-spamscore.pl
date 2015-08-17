	#absurd-spamscore: IP block on mail server detected a message with a spam score integer greater or equal to 90
	if (($lgfile eq $config{CUSTOM8_LOG}) and ($line =~ /^[a-zA-Z0-9:=().-\s]{2,}\[(\S+)\]:[a-zA-Z0-9=<\-@.>\s]{2,}:\s+"[a-zA-Z0-9=<\-@.>()[\]\s]{2,}:\d+\sbecause mail server detected a message with a spam score integer greater or equal to\s\d+"/)) {
		return ("Kakashi kill a spammer server",$1,"kakashi-absurd-spamscore","2","","1");
	}
