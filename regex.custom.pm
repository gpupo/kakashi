#!/usr/bin/perl
# This file is part of gpupo/kakashi
# http://www.g1mr.com/kakashi
#
# (c) Gilmar Pupo <g@g1mr.com>
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
#
# Warning: This file is generated automatically.
# To improve it, see bin/build.sh and edit the corresponding source code
# build-2015-10-28-16h10

sub custom_line {
	my $line = shift;
	my $lgfile = shift;
  ### MTA Rules
	#absurd-spamscore: IP block on mail server detected a message with a spam score integer greater or equal to 90
	if (($lgfile eq $config{CUSTOM8_LOG}) and ($line =~ /^[a-zA-Z0-9:=().-\s]{2,}\[(\S+)\]:[a-zA-Z0-9=<\-@.>\s]{2,}:\s+"[a-zA-Z0-9=<\-@.>()[\]\s]{2,}:\d+\sbecause mail server detected a message with a spam score integer greater or equal to\s\d+"/)) {
		return ("Kakashi kill a spammer server",$1,"kakashi-absurd-spamscore","2","","1");
	}
    # could-not-complete-sender-verify
    if (($lgfile eq $config{CUSTOM8_LOG}) and ($line =~ /^[a-zA-Z0-9:=().-\s]{2,}\[(\S+)\]:[a-zA-Z0-9=<\-@.>\s]{2,}:\s+Could not complete sender verify/)) {
    	return ("Kakashi knocked a ghost server",$1,"kakashi-could-not-complete-sender-verify","2","","0");
    }
	#host-is-ratelimited
	if (($lgfile eq $config{CUSTOM8_LOG}) and ($line =~ /^[a-zA-Z0-9:=().-\s]{2,}\[(\S+)\]:[a-zA-Z0-9=<\-@.>\"\s]{2,}:\s"+Host is ratelimited\s+[\S\s]{2,}/)) {
		return ("Kakashi knocked other opponent",$1,"kakashi-host-is-ratelimited","3","","0");
	}

	#host-lookup-did-not-complete
	if (($lgfile eq $config{CUSTOM8_LOG}) and ($line =~ /^[a-zA-Z0-9:=().-\s]{2,}\[(\S+)\]:[a-zA-Z0-9=<\-@.>\s]{2,}:\s+host lookup did not complete/)) {
		return ("Kakashi knocked his opponent",$1,"kakashi-host-lookup-did-not-complete","2","","0");
	}

    #courier_login-authenticator-failed
    if (($lgfile eq $config{CUSTOM8_LOG}) and ($line =~ /^[a-zA-Z0-9:=().-\s]{2,}courier_login authenticator failed for\s+[\S\s]{2,}\[(\S+)\]:\d+:\s+\d+\sIncorrect authentication data\s+\S+/)) {
      return ("Kakashi knocked a bad guy",$1,"kakashi-courier_login-authenticator-failed","5","","0");
    }
### HTTP Rules

    # http-login-failed: watch http login fail with http status code 401 or 241(custom error code with bypass error pages override on mod_proxy)
    if (($lgfile eq $config{CUSTOM7_LOG}) and ($line =~ /^(\S+)\s+-[\s\/[\]:-\d+A-z".]{2,}\s+HTTP\/1.\d"\s+((\b401\b)|(\b241\b))\s+\d+\s+[\S ]{2,}/)) {
      return ("Kakashi knocked a housebreaker",$1,"kakashi-http-login-failed","15","80,443","0");
    }

	return 0;
}
1;
