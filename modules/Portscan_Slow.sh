#!/bin/bash

################ PORT SCANNING SLOW #############################################
nmap -p- -A -sU -Pn -T5 -iL subs.txt -oN nmapscan.txt
