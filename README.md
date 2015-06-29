# Kakashi

Custom regex matching for **CSF**

- [x] Temporary IP block
  - [x] Could not complete sender verify
  - [x] Host lookup did not complete
  - [x] Host is ratelimited
  - [x] Incorrect authentication data
  - [x] Watch http login fail with http status code 401
- [x] Permanant IP block
  - [x] On mail server detected a message with a absurd spam score
- [x] CLI Tools
  - [x] Enable SpamAssassin auto-deletion
- [ ] More
  - [ ] Using the Lightning Cutter
  - [ ] Takes up office as the Sixth Hokage

:information_source:**Caution!**: This is an extremely aggressive shinobi

## Install (sudo required)

1) Modify CUSTOM vars in your ``/etc/csf/csf.conf``:

    CUSTOM7_LOG = "/var/log/http/acess_log" #Customize!
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
