import zipfile 

zf = zipfile.ZipFile(filename)
with zipfile.open() as zipf:
     for entry in zipf:
        zipf.extract(entry, "/tmp/unpack/")
