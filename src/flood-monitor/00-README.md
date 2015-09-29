# Tool for checking high hits on httpd server
#
# Actions:
# - t) Temporary Deny
# - d) Deny
# - i) Info
# - a) Add to flood whitelist
#
# Usage
#
# - Interactive mode:
# ~/kakashi/bin/flood-monitor.sh
#
# - Non interactive With parameters:
# export DEFAULT_ACTION=t; export MEDIAN=300; export DENY_TTL=6h; ~/kakashi/bin/flood-monitor.sh
#
