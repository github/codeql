import subprocess
import re
import shutil

kotlinc = shutil.which('kotlinc')
if kotlinc is None:
    raise Exception("kotlinc not found")
output = subprocess.run([kotlinc, "-version"], text=True, stdout=subprocess.DEVNULL, stderr=subprocess.PIPE,
                        check=True).stderr
m = re.match(r'.* kotlinc-jvm ([0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z][a-zA-Z0-9]*)?) .*', output)
if m is None:
    raise Exception(f'Cannot detect version of kotlinc (got {output})')
print(m[1])
