import requests
import tarfile

url = "https://www.someremote.location/tarball.tar.gz"
response = requests.get(url, stream=True)

tarpath = "/tmp/tmp456/tarball.tar.gz"
with open(tarpath, "wb") as f:
      f.write(response.raw.read())

untarredpath = "/tmp/tmp123"
with tarfile.open(tarpath) as tar:
	for member in tar.getmembers():
		if member.name.startswith("/") or ".." in member.name:
			raise Exception("Path traversal identified in tarball")

		tar.extract(untarredpath, member)