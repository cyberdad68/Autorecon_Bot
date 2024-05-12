#!bin/bash

############################# GitHub LEaks ##############################
url=$1
name=$2

echo -n > /Autorecon/modules/results/$name-gitleaks.txt

python3 /Autorecon/modules/python-scripts/GitDorker/GitDorker.py -tf /Autorecon/modules/github_tokens.txt -q $url -d /Autorecon/modules/python-scripts/GitDorker/Dorks/alldorksv3 -ri -p -o /Autorecon/modules/results/$name-gitleaks.txt
