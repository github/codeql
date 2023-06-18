import tarfile
from fastapi import FastAPI


def tar_extract(tar_path):
    tarfile.open(tar_path)
    tarfile.open(tar_path)
    tarfile.TarFile.open(tar_path).extract("somefile")
    tarfile.TarFile.open(tar_path).extract("somefile")
    tarfile.TarFile.xzopen(tar_path).extract("somefile")
    tarfile.TarFile.gzopen(tar_path).extractall()
    tarfile.TarFile.open(tar_path).extractfile("file1.txt")
    tarfile.open(tar_path).extractfile("file1.txt")
    # not working
    tarInstance2 = tarfile.TarFile(tar_path)
    tarInstance2.extractfile("file1.txt")
    tarInstance2.extract("file1.txt")
    tarfile.TarFile().open(tar_path)
    # good
    tarfile.open(tar_path, mode="w")
    tarfile.TarFile.gzopen(tar_path, mode="w")
    tarfile.TarFile.open(tar_path, mode="r:")


app = FastAPI()


@app.post("/zipbomb")
async def zipbomb(bar_id):
    tar_extract(bar_id)
    return {"message": "non-async"}
