import requests
import shutil

url = "https://www.someremote.location/tarball.tar.gz"
response = requests.get(url, stream=True)

tarpath = "/tmp/tmp456/tarball.tar.gz"
with open(tarpath, "wb") as f:
      f.write(response.raw.read())

untarredpath = "/tmp/tmp123"
shutil.unpack_archive(tarpath, untarredpath) # $result=BAD


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
        shutil.unpack_archive(to_path, unpack_path) # $result=BAD
        to_path = unpack_path


# A source catching an S3 filename download
# see boto3: https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/s3.html#S3.Client.download_file
import boto3
import os

remote_ziped_name = "remote_name.tar.gz"
base_dir = "/tmp/basedir"
local_ziped_path = os.path.join(base_dir, remote_ziped_name)
bucket_name = "mybucket"

s3 = boto3.client('s3')
s3.download_file(bucket_name, remote_ziped_name, local_ziped_path)
shutil.unpack_archive(local_ziped_path, base_dir) # $result=BAD


# wget
# see wget: https://pypi.org/project/wget/
import wget
import os

url = "https://some.remote/location/remote_name.tar.xz"
compressed_file = "/tmp/basedir/local_name.tar.xz"
base_dir = "/tmp/basedir"

# download(url, out, bar) contains out parameter
wget.download(url, compressed_file)
shutil.unpack_archive(compressed_file, base_dir) # $result=BAD

# download(url) returns filename
compressed_file = wget.download(url)
shutil.unpack_archive(compressed_file, base_dir) # $result=BAD


# A source coming from a CLI argparse module
# see argparse: https://docs.python.org/3/library/argparse.html
import argparse

parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('integers', metavar='N', type=int, nargs='+',
                    help='an integer for the accumulator')
parser.add_argument('filename', help='filename to be provided')

args = parser.parse_args()
compressed_file = args.filename
shutil.unpack_archive(compressed_file, base_dir) # $result=BAD