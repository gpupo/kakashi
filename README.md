# Kakashi

Security application for Linux servers

[![MIT License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://github.com/gpupo/kakashi/blob/master/LICENSE)
[![Gitter(help)](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/gpupo/kakashi?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

Custom regex matching for **CSF**

- Temporary IP block
  - Could not complete sender verify
  - Host lookup did not complete
  - Host is ratelimited
  - Incorrect authentication data
  - Watch http login fail with http status code 401
- Permanant IP block
  - On mail server detected a message with a absurd spam score
- CLI Tools
  - Enable SpamAssassin auto-deletion
  - Tool for checking high hits on httpd server

- [ ] More
  - [ ] Using the Lightning Cutter
  - [ ] Takes up office as the Sixth Hokage

:information_source:**Caution!**: This is an extremely aggressive shinobi

## Install (sudo required)

On a server with [CSF](http://www.configserver.com/cp/csf.html) previously installed:

1) Modify CUSTOM vars in your ``/etc/csf/csf.conf``:


    CUSTOM7_LOG = "/var/log/http/acess_log" #Customize!
    CUSTOM8_LOG = "/var/log/exim_mainlog"

    #Optional but recomended:
    DENY_IP_LIMIT = "1000"


2) Restart ``csf``:

    csf -r;

3) Get kakashi:

    git clone --depth=1 https://github.com/gpupo/kakashi.git ~/kakashi;

4) Put rules:

    sudo cp ~/kakashi/regex.custom.pm /etc/csf/regex.custom.pm && sudo service lfd restart;

Note: You can choose to use the more aggressive rules, replacing ``regex.custom.pm`` by ``regex.sharingan.pm`` in the above command.

After install, see logs on ``/var/log/lfd.log``:

    tail -f /var/log/lfd.log | grep kakashi;

5) Whitelist (recomended)

Add CSF whitelist IP address ranges (Gmail, Outlook, etc)

    sudo ~/kakashi/bin/csf-add-whitelist.sh;


## Update:

1) Execute:

    cd ~/kakashi/ && git pull;

2) Repeat step 4 (install)

## CLI

* Enable SpamAssassin auto-deletion in CPanel from CLI

### Flood Monitor

    sudo ~/kakashi/bin/flood-monitor.sh


## Contributors

- [@gpupo](https://github.com/gpupo)

Check ``CONTRIBUTING.md``

## License

MIT

## build

    ./bin/build.sh
