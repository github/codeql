

def extract_bad(zippath, dest):
    zipped = ZipFile(zippath)
    try:
        zipped.extractall(dest)
    finally:
        zipped.__del__()

def extract_good(zippath, dest):
    zipped = ZipFile(zippath)
    try:
        zipped.extractall(dest)
    finally:
        zipped.close()

