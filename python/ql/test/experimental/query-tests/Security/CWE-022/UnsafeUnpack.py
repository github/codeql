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

# the django upload functionality
# see HttpRequest.FILES: https://docs.djangoproject.com/en/4.1/ref/request-response/#django.http.HttpRequest.FILES
from django.shortcuts import render
from django.core.files.storage import FileSystemStorage
import shutil

def simple_upload(request):

      base_dir = "/tmp/baase_dir"
      if request.method == 'POST':
            # Read uploaded files by chunks of data
            # see chunks(): https://docs.djangoproject.com/en/4.1/ref/files/uploads/#django.core.files.uploadedfile.UploadedFile.chunks 
            savepath = os.path.join(base_dir, "tarball_compressed.tar.gz")
            with open(savepath, 'wb+') as wfile:
                  for chunk in request.FILES["ufile1"].chunks():
                        wfile.write(chunk)
            shutil.unpack_archive(savepath, base_dir) # $result=BAD

            # Write in binary the uploaded tarball
            myfile = request.FILES.get("ufile1")
            file_path = os.path.join(base_dir, "tarball.tar")
            with file_path.open('wb') as f:
                  f.write(myfile.read())
            shutil.unpack_archive(file_path, base_dir) # $result=BAD

            # Save uploaded files using FileSystemStorage Django API
            # see FileSystemStorage: https://docs.djangoproject.com/en/4.1/ref/files/storage/#django.core.files.storage.FileSystemStorage
            for ufile in  request.FILES.getlist():
                  fs = FileSystemStorage()
                  filename = fs.save(ufile.name, ufile)
                  uploaded_file_path = fs.path(filename)
                  shutil.unpack_archive(uploaded_file_path, base_dir) # $result=BAD
            
            return render(request, 'simple_upload.html')

      elif request.method == 'GET':
            return render(request, 'simple_upload.html')