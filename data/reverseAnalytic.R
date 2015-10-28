#!/usr/bin/env Rscript
require(dplyr)

reverse <- read.csv("analytic/reverse.csv", header=TRUE)
domains = aggregate(reverse$host, by = reverse[c('host')], length)
ips = aggregate(reverse$ip, by = reverse[c('host','ip')], length)

write.csv(domains, "analytic/reverse-hosts.csv")

whitelist = ips[ips$host %in% c("google.com ", "googlebot.com ", "yahoo.net ", "msn.com "),] %>%
  mutate(
    cddir = gsub("(\\d{1,3})$", "0/24", trimws(ip)),
    command = paste("csf -a ",cddir," 'Kakashi whitelist for reverse response", trimws(host),"';")
  ) %>%
  select(-ip, -x)

write.csv(unique(whitelist[3]), "analytic/reverse-whitelist-command.csv")
