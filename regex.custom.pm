#!/usr/bin/perl
# https://github.com/gpupo/kakashi
sub custom_line {
	my $line = shift;
	my $lgfile = shift;

	### MTA Rules

	# could-not-complete-sender-verify
	if (($lgfile eq $config{CUSTOM8_LOG}) and ($line =~ /^[a-zA-Z0-9:=().-\s]{2,}\[(\S+)\]:[a-zA-Z0-9=<\-@.>\s]{2,}:\s+Could not complete sender verify/)) {
		return ("kakashi:could-not-complete-sender-verify",$1,"could-not-complete-sender-verify","1","25,465,587","0");
	}

	#host-is-ratelimited
	if (($lgfile eq $config{CUSTOM8_LOG}) and ($line =~ /^[a-zA-Z0-9:=().-\s]{2,}\[(\S+)\]:[a-zA-Z0-9=<\-@.>\"\s]{2,}:\s"+Host is ratelimited\s+[\S\s]{2,}/)) {
		return ("kakashi:host-is-ratelimited",$1,"host-is-ratelimited","1","25,465,587","0");
	}

	#host-lookup-did-not-complete
	if (($lgfile eq $config{CUSTOM8_LOG}) and ($line =~ /^[a-zA-Z0-9:=().-\s]{2,}\[(\S+)\]:[a-zA-Z0-9=<\-@.>\s]{2,}:\s+host lookup did not complete/)) {
		return ("kakashi:host-lookup-did-not-complete",$1,"host-lookup-did-not-complete","1","25,465,587","0");
	}

	###MTA Login

	#courier_login-authenticator-failed
	if (($lgfile eq $config{CUSTOM8_LOG}) and ($line =~ /^[a-zA-Z0-9:=().-\s]{2,}courier_login authenticator failed for\s+[\S\s]{2,}\[(\S+)\]:\d+:\s+\d+\sIncorrect authentication data\s+\S+/)) {
		return ("kakashi:courier_login-authenticator-failed",$1,"courier_login-authenticator-failed","5","25,465,587","0");
	}

	return 0;
}
1;
