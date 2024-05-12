#!/bin/bash

########################## FUZZING ############################
python3 /Autorecon/modules/python-scripts/dirsearch/dirsearch.py -l subs.txt -e* -i 200,403,302 -t 50 --force-recursive -o fuzz.txt
