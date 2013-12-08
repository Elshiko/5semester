import sys

info = sys.argv[1]
info = info.split("$ ")

print(info[int(sys.argv[2]) - 1].replace("$",""))
