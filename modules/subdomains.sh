#!/bin/bash

url=$1
name=$2

echo -n > /app/results/$name-output.txt

/app/modules/binaries/subfinder -d $url > modules/temp/sub1
/app/modules/binaries/assetfinder $url | tee -a modules/temp/sub1
subscraper $url --censys-api 7bebd12b-693a-41ed-b259-b7edb647716f --censys-secret mK2Tn2oWpnYao1PlbtRfqeuOnZaFPKua | tee -a modules/temp/sub1
amass enum --passive -d $url | tee -a modules/temp/sub1
/app/modules/binaries/findomain-linux -q --target $url | tee -a modules/temp/sub1
python3 /app/modules/python-scripts/SubDomainizer.py -u $url -o modules/temp/subdomaininer.txt
/app/modules/binaries/github-subdomains -d $url -t github_tokens.txt -o modules/temp/sub5

# python3 "/app/modules/GitDorker/GitDorker.py" -tf /app/github_tokens.txt -q "paytm.com"  -ri -e 5 -d "/app/modules/GitDorker/Dorks/alldorksv3" | grep "\[+\]" | grep "git" | tee modules/temp/github-domainss.txt
# sed -r -i "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g" modules/temp/github-domainss.txt
# cat modules/temp/github-domainss.txt >> modules/temp/sub1

cat modules/temp/sub5 >> modules/temp/sub1
cat modules/temp/subdomaininer.txt >> modules/temp/sub1



curl -s "https://securitytrails.com/list/apex_domain/$url" | grep -Po "((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | grep ".$url" | sort -u | tee -a modules/temp/sub1
curl -s "https://rapiddns.io/subdomain/$url?full=1#result" | grep "<td><a" | cut -d '"' -f 2 | grep http | cut -d '/' -f3 | sed 's/#results//g' | sort -u | tee -a modules/temp/sub1
curl -s "https://crt.sh/?q=$url" | grep "<TD>" | grep $url | cut -d ">" -f2 | cut -d "<" -f1 | sort -u | sed '/^*/d' > modules/temp/sub2
curl -s "https://riddler.io/search/exportcsv?q=pld:$url" | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u > modules/temp/sub3
curl -s "https://jldc.me/anubis/subdomains/$url" | grep -Po "((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | cut -d "/" -f3 > modules/temp/sub4


echo "SUBDOMAINS" >> /app/results/$name-output.txt
printf "\n\n" >> /app/results/$name-output.txt

sort modules/temp/sub1 modules/temp/sub2 modules/temp/sub3 modules/temp/sub4 | uniq | tee modules/temp/$name-subs
sort modules/temp/sub1 modules/temp/sub2 modules/temp/sub3 modules/temp/sub4 | uniq | tee -a /app/results/$name-output.txt

printf "\n\n\n" >> /app/results/$name-output.txt
printf "##########################################################################################\n" >> /app/results/$name-output.txt
printf "##########################################################################################" >> /app/results/$name-output.txt
printf "\n\n\n" >> /app/results/$name-output.txt
rm -f modules/temp/*
