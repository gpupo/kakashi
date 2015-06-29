#!/usr/bin/perl
# https://github.com/gpupo/kakashi
sub custom_line {
	my $line = shift;
	my $lgfile = shift;

  ### MTA Rules

	# could-not-complete-sender-verify
	if (($lgfile eq $config{CUSTOM8_LOG}) and ($line =~ /^[a-zA-Z0-9:=().-\s]{2,}\[(\S+)\]:[a-zA-Z0-9=<\-@.>\s]{2,}:\s+Could not complete sender verify/)) {
		return ("Kakashi knocked a ghost server",$1,"kakashi-could-not-complete-sender-verify","1","","0");
	}

	#host-is-ratelimited
	if (($lgfile eq $config{CUSTOM8_LOG}) and ($line =~ /^[a-zA-Z0-9:=().-\s]{2,}\[(\S+)\]:[a-zA-Z0-9=<\-@.>\"\s]{2,}:\s"+Host is ratelimited\s+[\S\s]{2,}/)) {
		return ("Kakashi knocked other opponent",$1,"kakashi-host-is-ratelimited","1","","0");
	}

	#host-lookup-did-not-complete
	if (($lgfile eq $config{CUSTOM8_LOG}) and ($line =~ /^[a-zA-Z0-9:=().-\s]{2,}\[(\S+)\]:[a-zA-Z0-9=<\-@.>\s]{2,}:\s+host lookup did not complete/)) {
		return ("Kakashi knocked his opponent",$1,"kakashi-host-lookup-did-not-complete","1","","0");
	}

	#absurd-spamscore: IP block on mail server detected a message with a spam score integer greater or equal to 90
	if (($lgfile eq $config{CUSTOM8_LOG}) and ($line =~ /^[a-zA-Z0-9:=().-\s]{2,}\[(\S+)\]:[a-zA-Z0-9=<\-@.>\s]{2,}:\s+"[a-zA-Z0-9=<\-@.>()[\]\s]{2,}:\d+\sbecause mail server detected a message with a spam score integer greater or equal to\s\d+"/)) {
		return ("Kakashi kill a spammer server",$1,"kakashi-absurd-spamscore","1","","1");
	}

  ###MTA Login

	#courier_login-authenticator-failed
	if (($lgfile eq $config{CUSTOM8_LOG}) and ($line =~ /^[a-zA-Z0-9:=().-\s]{2,}courier_login authenticator failed for\s+[\S\s]{2,}\[(\S+)\]:\d+:\s+\d+\sIncorrect authentication data\s+\S+/)) {
		return ("Kakashi knocked a bad guy",$1,"kakashi-courier_login-authenticator-failed","5","","0");
	}


	return 0;
}
1;
