#!/bin/bash

################## NUCLEI #################################################
/Autorecon/modules/binaries/nuclei -update-templates
cat subs.txt | /Autorecon/modules/binaries/nuclei -c 300 -t -/nuclei-templates/ -o nuclei.txt  #Add here nuclei template path after -t 
# Download template from here- https://github.com/projectdiscovery/nuclei-templates
