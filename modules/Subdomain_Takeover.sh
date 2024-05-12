#!bin/bash

#################### CHECKING FOR SUBDOMAIN TAKEOVERS #################################################
nuclei -l /root/Desktop/subdomains-takeovers/domains.txt -t /nuclei-templates/subdomain-takeover/detect-all-takeovers.yaml
