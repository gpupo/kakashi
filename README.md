# Kakashi

Custom regex matching for **CSF**

- [x] Temporary IP block
  - [x] Could not complete sender verify
  - [x] Host lookup did not complete
  - [x] Host is ratelimited
  - [x] Incorrect authentication data
- [x] Permanant IP block
  - [x] On mail server detected a message with a absurd spam score
- [x] CLI Tools
  - [x] Enable SpamAssassin auto-deletion
- [ ] More
  - [ ] Using the Lightning Cutter
  - [ ] Takes up office as the Sixth Hokage

:information_source:**Caution!**: This is an extremely aggressive shinobi

## Install (sudo required)

1) Modify ``CUSTOM8_LOG`` in ``/etc/csf/csf.conf``:

    CUSTOM8_LOG = "/var/log/exim_mainlog"

2) Restart ``csf``:

    csf -r;

3) Get kakashi:

    git clone --depth=1 https://github.com/gpupo/kakashi.git ~/kakashi;

4) Put rules:

    sudo cp ~/kakashi/regex.custom.pm /etc/csf/regex.custom.pm && sudo service lfd restart;


After install, see logs on ``/var/log/lfd.log``:

    tail -f /var/log/lfd.log | grep kakashi;


## Update:

1) Execute:

    cd ~/kakashi/ && git pull;

2) Repeat step 4 (install)

## CLI

* Enable SpamAssassin auto-deletion in CPanel from CLI

## Contributors

- [@gpupo](https://github.com/gpupo)

Check CONTRIBUTING.md

## License

MIT


## Doc

Custom regex matching can be added to this file without it being overwritten
by csf upgrades. The format is slightly different to regex.pm to cater for
additional parameters.

The regex matches in this file will supercede the matches in regex.pm

### Example:

```PERL

	if (($lgfile eq $config{CUSTOM1_LOG}) and ($line =~ /^\S+\s+\d+\s+\S+ \S+ pure-ftpd: \(\?\@(\d+\.\d+\.\d+\.\d+)\) \[WARNING\] Authentication failed for user/)) {
		return ("Failed myftpmatch login from",$1,"myftpmatch","5","20,21","1");
	}

```

The return values from this example are as follows:

``Failed myftpmatch login from`` = text for custom failure message
``$1`` = the offending IP address
``myftpmatch`` = a unique identifier for this custom rule, must be alphanumeric and have no spaces
``5`` = the trigger level for blocking
``20,21`` = the ports to block the IP from in a comma separated list, only used if LF_SELECT enabled
``1`` = **0/temporary** or **1/permanant** IP block, *only used if LF_TRIGGER is disabled*
