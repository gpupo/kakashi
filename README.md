# kakashi - Custom regex matching for CSF.

## Install

1) Modify ``CUSTOM8_LOG`` in ``/etc/csf/csf.conf``:

    CUSTOM8_LOG = "/var/log/exim_mainlog"

2) Restart ``csf``:

    csf -r;

3) Get kakashi:

    cd ~/
    git clone --depth=1 https://github.com/gpupo/kakashi.git;

4) Put rules:

    cp ~/kakashi/regex.custom.pm /etc/csf/regex.custom.pm;
    service lfd restart;


After install, see logs on ``/var/log/lfd.log``


## Update:

1) Execute:

    cd ~/kakashi/ && git pull;

2) Repeat step 4 (install)

## Contributors

- [@gpupo](https://github.com/gpupo)

## License

MIT


## Doc

Custom regex matching can be added to this file without it being overwritten
by csf upgrades. The format is slightly different to regex.pm to cater for
additional parameters. You need to specify the log file that needs to be
scanned for log line matches in csf.conf under CUSTOMx_LOG. You can scan up
to 9 custom logs (CUSTOM1_LOG .. CUSTOM9_LOG)

The regex matches in this file will supercede the matches in regex.pm

### Example:

```PERL

	if (($lgfile eq $config{CUSTOM1_LOG}) and ($line =~ /^\S+\s+\d+\s+\S+ \S+ pure-ftpd: \(\?\@(\d+\.\d+\.\d+\.\d+)\) \[WARNING\] Authentication failed for user/)) {
		return ("Failed myftpmatch login from",$1,"myftpmatch","5","20,21","1");
	}

```

The return values from this example are as follows:

"Failed myftpmatch login from" = text for custom failure message
$1 = the offending IP address
"myftpmatch" = a unique identifier for this custom rule, must be alphanumeric and have no spaces
"5" = the trigger level for blocking
"20,21" = the ports to block the IP from in a comma separated list, only used if LF_SELECT enabled
"1" = 0/temporary or 1/permanant IP block, only used if LF_TRIGGER is disabled
