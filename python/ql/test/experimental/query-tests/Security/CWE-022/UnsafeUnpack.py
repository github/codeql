import requests
import shutil
import os 

from flask import Flask, request
app = Flask(__name__)

# Consider any RemoteFlowSource as a source
@app.route("/download_from_url")
def download_from_url():
    filename = request.args.get('filename', '')
    if not filename:
        response = requests.get(filename, stream=True)
    
        tarpath = "/tmp/tmp456/tarball.tar.gz"
        with open(tarpath, "wb") as f:
              f.write(response.raw.read())

        untarredpath = "/tmp/tmp123"
        shutil.unpack_archive(tarpath, untarredpath) # $result=BAD
        

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


# A source coming from a CLI and downloaded
import argparse
import requests

parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('integers', metavar='N', type=int, nargs='+',
                    help='an integer for the accumulator')
parser.add_argument('filename', help='url to filename to be provided')

args = parser.parse_args()
url_filename = args.filename

response = requests.get(url_filename, stream=True)

tarpath = "/tmp/tmp456/tarball.tar.gz"
with open(tarpath, "wb") as f:
      f.write(response.raw.read())
      
shutil.unpack_archive(tarpath, base_dir) # $result=BAD