import re
domain = "htpswww.paytm.com"
pattern = re.compile("w{0,3}\w*?\.(\w*?\.)?\w{2,3}\S*|www\.(\w*?\.)?\w*?\.\w{2,3}\S*|(\w*?\.)?\w*?\.\w{2,3}[\/\?]\S*")
# if bool(re.fullmatch(pattern, domain)):
#     print("yes")
# else:
#     print("No")
x = re.search(pattern, domain, flags=0)
print(x[0])
print(type(x[0]))


