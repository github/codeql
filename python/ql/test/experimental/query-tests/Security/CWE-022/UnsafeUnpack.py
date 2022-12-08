import requests
import shutil

url = "https://www.someremote.location/tarball.tar.gz"
response = requests.get(url, stream=True)

tarpath = "/tmp/tmp456/tarball.tar.gz"
with open(tarpath, "wb") as f:
      f.write(response.raw.read())

untarredpath = "/tmp/tmp123"
shutil.unpack_archive(tarpath, untarredpath)


import tempfile
import os
from urllib import request
import contextlib
import shutil

unpack = True
to_path = "/tmp/tmp123"
uri = "https://www.goog.com/zzz.tar.gz"
scheme = "https"

with tempfile.TemporaryDirectory() as temp_dir:
    if unpack and (str(uri).endswith("zip") or str(uri).endswith("tar.gz")):
        unpack_path = to_path
        to_path = temp_dir
    else:
        unpack_path = None
    if scheme in ["http", "https", "ftp"]:
        if os.path.isdir(to_path):
            to_path = os.path.join(to_path, os.path.basename(uri))
        url = uri
        url_response = request.urlopen(url)
        with contextlib.closing(url_response) as fp:
            with open(to_path, "wb") as out_file:
                block_size = DEFAULT_BUFFER_SIZE * 8
                while True:
                    block = fp.read(block_size)
                    if not block:
                        break
                    out_file.write(block)
    else:
        if scheme == "oci" and not storage_options:
            storage_options = default_signer()
        fs = fsspec.filesystem(scheme, **storage_options)
        if os.path.isdir(to_path):
            to_path = os.path.join(
                to_path, os.path.basename(str(uri).rstrip("/"))
            )
        fs.get(uri, to_path, recursive=True)
    if unpack_path:
        shutil.unpack_archive(to_path, unpack_path)
        to_path = unpack_path
