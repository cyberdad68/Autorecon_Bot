#!/bin/bash



################### Sorting Parameters #####################################
cat url.txt | /Autorecon/modules/binaries/gf sqli > sqli.txt
cat url.txt | /Autorecon/modules/binaries/gf ssrf > ssrf.txt
cat url.txt | /Autorecon/modules/binaries/gf redirect > redirect.txt
cat url.txt | /Autorecon/modules/binaries/gf rce > rce.txt
cat url.txt | /Autorecon/modules/binaries/gf idor > idor.txt
cat url.txt | /Autorecon/modules/binaries/gf lfi > lfi.txt
cat url.txt | /Autorecon/modules/binaries/gf ssti > ssti.txt
