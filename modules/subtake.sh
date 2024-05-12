#!/bin/bash
# subdomain takeover checker

url=$1
name=$2

echo -n > /Autorecon/modules/results/$name-takeoverSubzy.txt
subzy -concurrency 90 -timeout 5 -hide_fails -targets /Autorecon/modules/results/$name-output.txt | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g" | tee -a /Autorecon/modules/results/$name-takeoverSubzy.txt

