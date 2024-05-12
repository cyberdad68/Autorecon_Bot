#!/bin/bash


################SUBDOMAIN ENUMERATION#########################


domain=$1
name=$2



amass enum -passive -d $domain -o subs1.txt

/Autorecon/modules/binaries/subfinder -d $domain -t 100 -o subs2.txt
cat subs2.txt | /Autorecon/modules/binaries/anew subs1.txt

subscraper $domain --censys-api 7bebd12b-693a-41ed-b259-b7edb647716f --censys-secret mK2Tn2oWpnYao1PlbtRfqeuOnZaFPKua -o subs3.txt
cat subs3.txt | /Autorecon/modules/binaries/anew subs1.txt

/Autorecon/modules/binaries/github-subdomains -d $domain -t /Autorecon/modules/github_tokens.txt -o subs4.txt
cat subs4.txt | /Autorecon/modules/binaries/anew subs1.txt

rm -f subs2.txt subs3.txt subs4.txt



# /Autorecon/modules/binaries/assetfinder --subs-only $domain > subs5.txt
# cat subs5.txt | /Autorecon/modules/binaries/anew subs1.txt


################CHECKING FOR LIVE SUBDOMAINS (COMMON & UNCOMMON PROBING)#########
echo -n > /Autorecon/modules/results/$name-output.txt

cat subs1.txt | /Autorecon/modules/binaries/httpx > /Autorecon/modules/results/$name-output.txt
cat subs1.txt | /Autorecon/modules/binaries/httprobe -p http:81 -p http:8008 -p https:8008 -p https:3001 -p http:8000 -p https:8000 -p http:8080 -p https:8080 -p https:8443 -p https:10000 -p -s -c 100 | tee live2.txt
cat live2.txt | /Autorecon/modules/binaries/anew /Autorecon/modules/results/$name-output.txt # <<<<<<<---------------- THIS IS THE FINAL LIVE DOMAIN OUTPUT (subs.txt)

rm -f subs1.txt live2.txt
