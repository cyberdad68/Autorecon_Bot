#!bin/bash

################################### CHECKS FOR BIGIP VUL #################################
Big Ip:
curl -sk 'https://$1/tmui/login.jsp/.. ; /tmui/ util/getTabSet.jsp?tabId=Vulnerable' | grep -q Vulnerable && printf '\033 [0; 31mVulnerable\n' || printf '\033 [0;32mNot Vulnerable\n'
