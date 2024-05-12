#!/bin/bash
mkdir -p recon/$1
cd recon/$1

################SUBDOMAIN ENUMERATION#########################

amass enum -passive -d $1 -o subs1.txt
/Autorecon/modules/binaries/subfinder -d $1 -all -recursive -t 50 -o subs2.txt
cat subs1.txt >> subs2.txt
subscraper $1 --censys-api 7bebd12b-693a-41ed-b259-b7edb647716f --censys-secret mK2Tn2oWpnYao1PlbtRfqeuOnZaFPKua -o subs3.txt
cat subs2.txt >> subs3.txt
/Autorecon/modules/binaries/github-subdomains -d $1 -t "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" -o subs4.txt
cat subs3.txt >> subs4.txt
python3 /Autorecon/modules/python-scripts/Sublist3r/sublist3r.py -b -d $1 -o subs5.txt
cat subs4.txt >> subs5.txt
sort subs5.txt | uniq > subsfinal.txt

################CHECKING FOR LIVE SUBDOMAINS (COMMON & UNCOMMON PROBING)#########
cat subsfinal.txt | /Autorecon/modules/binaries/httpx > live1.txt
cat subsfinal.txt | /Autorecon/modules/binaries/httprobe -p http:81 -p http:8008 -p https:8008 -p https:3001 -p http:8000 -p https:8000 -p http:8080 -p https:8080 -p https:8443 -p https:10000 -p -s -c 100 | tee live2.txt
cat live1.txt >> live2.txt
sort live2.txt | uniq > subs.txt

############### SUBDOMAIN TAKEOVER ############################

################ URL ENUMERATIONS #######################################
cat subs.txt | /Autorecon/modules/binaries/waybackurls > url1.txt
cat subs.txt | /Autorecon/modules/binaries/gau -o url2.txt
cat url1.txt >> url2.txt
cat subs.txt | /Autorecon/modules/binaries/gauplus -o url3.txt
cat url2.txt >> url3.txt
# python3 paramspider.py -d $1 #Check

arjun -i subs.txt -t 100 --passive -oT url4.txt
cat url3.txt >> url4.txt
sort url4.txt | uniq > url.txt
################### Sorting Parameters #####################################
cat url.txt | /Autorecon/modules/binaries/gf sqli > sqli.txt
cat url.txt | /Autorecon/modules/binaries/gf ssrf > ssrf.txt
cat url.txt | /Autorecon/modules/binaries/gf redirect > redirect.txt
cat url.txt | /Autorecon/modules/binaries/gf rce > rce.txt
cat url.txt | /Autorecon/modules/binaries/gf idor > idor.txt
cat url.txt | /Autorecon/modules/binaries/gf lfi > lfi.txt
cat url.txt | /Autorecon/modules/binaries/gf ssti > ssti.txt
################ PORT SCANNING #############################################
cat subs.txt | /Autorecon/modules/binaries/naabu > naabuPort.txt
nmap -p- -A -sU -Pn -T4 -iL subs.txt -oN nmapscan.txt
################## NUCLEI #################################################
cat subs.txt | /Autorecon/modules/binaries/nuclei -c 300 -t -/nuclei-templates/ -o nuclei.txt
########################## FUZZING ############################
python3 /Autorecon/modules/python-scripts/dirsearch/dirsearch.py -l subs.txt -e* -i 200,403,302 -t 50 --force-recursive -o fuzz.txt
############### CMS HUNTING ##################################
# cd recon/tools/XAttacker
# perl XAttacker.pl -l subs.txt > CMS.txt
################# XSS ###################################
/Autorecon/modules/binaries/dalfox -b hahwul.xss.ht file url.txt > vulxss.txt -w 100
##############
