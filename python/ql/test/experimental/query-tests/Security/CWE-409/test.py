import tarfile
import zipfile
from fastapi import FastAPI

app = FastAPI()


@app.post("/bomb")
async def bomb(file_path):
    zipfile.ZipFile(file_path, "r").extract("file1")
    zipfile.ZipFile(file_path, "r").extractall()

    with zipfile.ZipFile(file_path) as myzip:
        with myzip.open('ZZ') as myfile:
            a = myfile.readline()

    with zipfile.ZipFile(file_path) as myzip:
        with myzip.open('ZZ', mode="w") as myfile:
            myfile.write(b"tmpppp")

    zipfile.ZipFile(file_path).read("aFileNameInTheZipFile")

    tarfile.open(file_path).extractfile("file1.txt")
    tarfile.TarFile.open(file_path).extract("somefile")
    tarfile.TarFile.xzopen(file_path).extract("somefile")
    tarfile.TarFile.gzopen(file_path).extractall()
    tarfile.TarFile.open(file_path).extractfile("file1.txt")

    tarfile.open(file_path, mode="w")
    tarfile.TarFile.gzopen(file_path, mode="w")
    tarfile.TarFile.open(file_path, mode="r:")
    import shutil

    shutil.unpack_archive(file_path)

    import lzma

    lzma.open(file_path)
    lzma.LZMAFile(file_path).read()

    import bz2

    bz2.open(file_path)
    bz2.BZ2File(file_path).read()

    import gzip

    gzip.open(file_path)
    gzip.GzipFile(file_path)

    import pandas

    pandas.read_csv(filepath_or_buffer=file_path)

    pandas.read_table(file_path, compression='gzip')
    pandas.read_xml(file_path, compression='gzip')

    pandas.read_csv(filepath_or_buffer=file_path, compression='gzip')
    pandas.read_json(file_path, compression='gzip')
    pandas.read_sas(file_path, compression='gzip')
    pandas.read_stata(filepath_or_buffer=file_path, compression='gzip')
    pandas.read_table(file_path, compression='gzip')
    pandas.read_xml(path_or_buffer=file_path, compression='gzip')

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
