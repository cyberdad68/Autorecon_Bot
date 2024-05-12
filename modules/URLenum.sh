#!/bin/bash

url=$1
name=$2


################ URL ENUMERATIONS #######################################

echo -n > /Autorecon/modules/results/$name-urls.txt

cat /Autorecon/modules/results/$name-output.txt | /Autorecon/modules/binaries/waybackurls > url1.txt
cat /Autorecon/modules/results/$name-output.txt | /Autorecon/modules/binaries/gau -o url2.txt
cat url1.txt >> url2.txt
cat /Autorecon/modules/results/$name-output.txt | /Autorecon/modules/binaries/gauplus -o url3.txt
cat url2.txt >> url3.txt
python3 /Autorecon/modules/python-scripts/ParamSpider/paramspider.py -d $url -l high -q -o url4.txt 
cat url3.txt >> url4.txt 
arjun -i subs.txt -t 100 --passive -oT url5.txt
cat url4.txt >> url5.txt
cat url5.txt | uro > /Autorecon/modules/results/$name-urls.txt #Check URO PAth HEre
