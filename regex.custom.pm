#!/usr/bin/perl
sub custom_line {
	my $line = shift;
	my $lgfile = shift;

# Do not edit before this point

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

# Do not edit beyond this point
	return 0;
}
1;
