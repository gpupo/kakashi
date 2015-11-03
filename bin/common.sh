SAMPLE_SIZE=${SAMPLE_SIZE:-100};
MEDIAN=${MEDIAN:-300};
DENY_TTL=${DENY_TTL:-2h};
DEFAULT_ACTION=${DEFAULT_ACTION:-};
REVERSE_CHECK=${REVERSE_CHECK:-false};
touch ~/.kakashi/allow ~/.kakashi/reverse.deny ~/.kakashi/reverse.allow ~/.kakashi/reverse.suspect ~/.kakashi/config

#Custom config file for overwrite default values
source ~/.kakashi/config
executionId=$(date +%Y-%m-%d-%H:%M);
