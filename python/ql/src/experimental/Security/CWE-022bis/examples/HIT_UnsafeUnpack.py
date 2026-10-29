import requests
import shutil

url = "https://www.someremote.location/tarball.tar.gz"
response = requests.get(url, stream=True)

tarpath = "/tmp/tmp456/tarball.tar.gz"
with open(tarpath, "wb") as f:
      f.write(response.raw.read())

untarredpath = "/tmp/tmp123"
shutil.unpack_archive(tarpath, untarredpath)