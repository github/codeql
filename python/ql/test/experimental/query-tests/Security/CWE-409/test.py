import tarfile
import zipfile
import tty # this import is only here so logic for detecting stdlib works
from fastapi import FastAPI

app = FastAPI()


@app.post("/bomb")
async def bomb(file_path):
    zipfile.ZipFile(file_path, "r").extract("file1")  # $ result=BAD
    zipfile.ZipFile(file_path, "r").extractall()  # $ result=BAD

    with zipfile.ZipFile(file_path) as myzip:
        with myzip.open('ZZ') as myfile:  # $ result=BAD
            a = myfile.readline()

    with zipfile.ZipFile(file_path) as myzip:
        with myzip.open('ZZ', mode="w") as myfile: # $ SPURIOUS: result=BAD
            myfile.write(b"tmpppp")

    zipfile.ZipFile(file_path).read("aFileNameInTheZipFile")  # $ result=BAD

    tarfile.open(file_path).extractfile("file1.txt")  # $ result=BAD
    tarfile.TarFile.open(file_path).extract("somefile")  # $ result=BAD
    tarfile.TarFile.xzopen(file_path).extract("somefile")  # $ result=BAD
    tarfile.TarFile.gzopen(file_path).extractall()  # $ result=BAD
    tarfile.TarFile.open(file_path).extractfile("file1.txt")  # $ result=BAD

    tarfile.open(file_path, mode="w") # ok, writing
    tarfile.TarFile.gzopen(file_path, mode="w") # ok, writing
    tarfile.TarFile.open(file_path, mode="r:") # potential problem, depending on usage
    import shutil

    shutil.unpack_archive(file_path)  # $ result=BAD

    import lzma

    lzma.open(file_path)  # $ result=BAD
    lzma.LZMAFile(file_path).read()  # $ result=BAD

    import bz2

    bz2.open(file_path)  # $ result=BAD
    bz2.BZ2File(file_path).read()  # $ result=BAD

    import gzip

    gzip.open(file_path)  # $ result=BAD
    gzip.GzipFile(file_path)  # $ result=BAD

    import pandas

    pandas.read_csv(filepath_or_buffer=file_path)  # $ result=BAD

    pandas.read_table(file_path, compression='gzip')  # $ result=BAD
    pandas.read_xml(file_path, compression='gzip')  # $ result=BAD

    pandas.read_csv(filepath_or_buffer=file_path, compression='gzip')  # $ result=BAD
    pandas.read_json(file_path, compression='gzip')  # $ result=BAD
    pandas.read_sas(file_path, compression='gzip')  # $ result=BAD
    pandas.read_stata(filepath_or_buffer=file_path, compression='gzip')  # $ result=BAD
    pandas.read_table(file_path, compression='gzip')  # $ result=BAD
    pandas.read_xml(path_or_buffer=file_path, compression='gzip')  # $ result=BAD

    # no compression no DOS
    pandas.read_table(file_path, compression='tar')
    pandas.read_xml(file_path, compression='tar')

    pandas.read_csv(filepath_or_buffer=file_path, compression='tar')
    pandas.read_json(file_path, compression='tar')
    pandas.read_sas(file_path, compression='tar')
    pandas.read_stata(filepath_or_buffer=file_path, compression='tar')
    pandas.read_table(file_path, compression='tar')
    pandas.read_xml(path_or_buffer=file_path, compression='tar')

    return {"message": "bomb"}
