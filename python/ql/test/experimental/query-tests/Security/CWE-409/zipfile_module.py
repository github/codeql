import zipfile
from io import BytesIO
from urllib import request
import requests
from fastapi import FastAPI, File, UploadFile
from typing import List, Annotated


def zip_extract(zip_path):
    # we can have PyZipFile instead of ZipFile too
    zipfile.ZipFile(zip_path, "r").extract("0", "./tmp/")
    zipFileObj = zipfile.ZipFile(zip_path, "r")
    zipFileObj2 = zipFileObj
    # zipfile.ZipFile("user_input").extract(member="file_name") Consume a lot of CPU,Storage
    zipFileObj2.extract("0", "./tmp/")
    # zipfile.ZipFile("user_input").extract(member=ZipInfo_object) Consume a lot of CPU,Storage
    zipFileObj.extract(zipFileObj.infolist()[0], "./tmp/")


def zip_extractall(zip_path):
    import httpx
    filex = httpx.get(zip_path).read()
    zipfile.ZipFile(BytesIO(filex), "r").extractall()
    zipFileObj = zipfile.ZipFile(zip_path, "r")
    for infolist in zipFileObj.infolist():
        Decompression_ratio = infolist.file_size / infolist.compress_size
        if Decompression_ratio > 10:
            return
    # zipfile.ZipFile("user_input").extractall() Consume a lot of CPU,Storage
    zipFileObj.extractall("./tmp/")  # Sensitive
    zipFileObj.close()


def zip_read_obj(zip_path):
    # zipfile.ZipFile("user_input").open("file_name").read() Consume a lot of CPU,RAM,Storage
    with zipfile.ZipFile(zip_path) as myzip:
        with myzip.open('ZZ') as myfile:
            a = myfile.readline()

    file = requests.get(zip_path)
    zipfile.ZipFile(BytesIO(file.raw), "w").open("aa")
    zipfile.ZipFile(BytesIO(file.raw), "r").open("aa")

    with zipfile.ZipFile(zip_path) as myzip:
        with myzip.open('ZZ', mode="r") as myfile:
            a = next(myfile)

    with zipfile.ZipFile(zip_path) as myzip:
        with myzip.open('ZZ', mode="w") as myfile:
            a = myfile.write(b"tmpppp")

    myzip = zipfile.PyZipFile(zip_path)
    myzip.read(myzip.infolist()[0])

    zipfile.ZipFile(BytesIO(request.urlopen(zip_path).read())
                    ).read("aFileNameInTheZipFile")

    with zipfile.ZipFile(zip_path, 'w') as dst_zip:
        with zipfile.ZipFile(zip_path) as src_zip:
            for info in src_zip.infolist():
                if info.filename.startswith('classes'):
                    dst_zip.writestr(info, src_zip.read(info))


def safeUnzip(zipFileName):
    buffer_size = 2 ** 10 * 8
    total_size = 0
    SIZE_THRESHOLD = 2 ** 10 * 100
    with zipfile.ZipFile(zipFileName) as myzip:
        for fileinfo in myzip.infolist():
            content = b''
            with myzip.open(fileinfo.filename, mode="r") as myfile:
                chunk = myfile.read(buffer_size)
                while chunk:
                    chunk = myfile.read(buffer_size)
                    total_size += buffer_size
                    if total_size > SIZE_THRESHOLD:
                        print("Bomb detected")
                        return
                    content += chunk
                print(bytes.decode(content, 'utf-8'))
    return "No Bombs!"


app = FastAPI()


@app.post("/zipbomb")
async def zipbomb(bar_id):
    zip_extractall(bar_id)
    zip_extract(bar_id)
    zip_read_obj(bar_id)
    safeUnzip(bar_id)
    return {"message": "non-async"}


@app.post("/zipbomb2")
async def zipbomb2(file: UploadFile):
    with zipfile.ZipFile(file.file) as myzip:
        with myzip.open('ZZ') as myfile:
            a = myfile.readline()
    return {"message": "non-async"}


@app.post("/zipbomb2")
async def create_file(file: Annotated[bytes | None, File()] = None):
    with zipfile.ZipFile(file) as myzip:
        with myzip.open('ZZ') as myfile:
            a = myfile.readline()
    return {"message": "non-async"}


@app.post("/uploadMultipleFiles")
def upload(files: List[UploadFile] = File(...)):
    for file in files:
        with zipfile.ZipFile(file.file) as myzip:
            with myzip.open('ZZ') as myfile:
                a = myfile.readline()
    return {"message": "non-async"}


@app.post("/files/")
async def create_files(files: Annotated[list[bytes], File()]):
    for file in files:
        with zipfile.ZipFile(file.file) as myzip:
            with myzip.open('ZZ') as myfile:
                a = myfile.readline()
    return {"file_sizes": [len(file) for file in files]}
