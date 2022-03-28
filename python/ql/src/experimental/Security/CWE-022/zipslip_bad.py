import zipfile
import shutil

def unzip(filename):
    with tarfile.open(filename) as zipf:
    #BAD : This could write any file on the filesystem.
        for entry in zipf:
            shutil.copyfile(entry, "/tmp/unpack/")
          
def unzip4(filename):
    zf = zipfile.ZipFile(filename)
    filelist = zf.namelist()
    for filename in filelist:
        with zf.open(filename) as srcf:
            shutil.copyfileobj(srcf, dstfile)

