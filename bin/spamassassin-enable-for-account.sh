#!/bin/bash

USERNAME=$1

if [ "x$1" = "x" ] ; then
  echo "Usage: $0 username"
  exit
fi


touch "/home/$USERNAME/.spamassassinenable"
chown "$USERNAME." "/home/$USERNAME/.spamassassinenable"

mkdir -p "/home/$USERNAME/.spamassassin"
chown "$USERNAME." "/home/$USERNAME/.spamassassin"

cat < "/home/$USERNAME/.spamassassin/user_prefs"
required_score 2
rewrite_header subject *** SPAM ***
EOF

chown "$USERNAME." "/home/$USERNAME/.spamassassin/user_prefs"


cat < "/home/$USERNAME/.cpanel/filter.yaml"
---
filter:
  -
    actions:
      -
        action: save
        dest: /dev/null
    filtername: Generated SpamAssassin Discard Rule
    rules:
      -
        match: contains
        opt: or
        part: "$h_X-Spam-Bar:"
        val: ++
EOF

chown "$USERNAME." "/home/$USERNAME/.cpanel/filter.yaml"
