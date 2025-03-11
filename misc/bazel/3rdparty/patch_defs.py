import sys
import re
import pathlib

label_re = re.compile(r'"@(vendor.*)//:(.+)-([\d.]+)"')

file = pathlib.Path(sys.argv[1])
temp = file.with_suffix(f'{file.suffix}.tmp')


with open(file) as input, open(temp, "w") as output:
    for line in input:
        line = label_re.sub(lambda m: f'"@{m[1]}__{m[2]}-{m[3]}//:{m[2].replace("-", "_")}"', line)
        output.write(line)

temp.rename(file)
