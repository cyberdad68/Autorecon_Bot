"# Autorecon" 

We made this tool to automate the recon process and save the time of Bug Hunters. It really give headache as to always type such command and then wait to complete one command and then type other command. So We collected some of the tools which is widely used in the bugbounty field and some of our own One-Liners Commands which does not give any false positives(Not Available in Market). In this script we used Assetfinder, subfinder, amass, httpx, sublister, gauplus,gf patterns etc and then it uses dirsearch, dalfox, nuclei, kxss etc to find some low-hanging fruits.

The script first enumerates all the subdomains of the given target domain using assetfinder, sublister, subfinder and amass then filters all live domains from the whole subdomain list then it scans for subdomain takeover using nuclei etc. Then it uses gauplus to extract paramters of the given subdomains then it use gf patterns to filters xss, ssti, ssrf, sqli, rce params from that given subdomains and then it scans for low hanging fruits as well. Then it'll save all the output in a text file like target-xss.txt. Then it will send the notifications about the scan on our Telegram Bot (@TeleCon).


https://github.com/user-attachments/assets/40484fd9-6f10-4a17-8c4a-695e3fffc93e

