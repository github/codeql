import zipfile


def Bad(zip_path):
    zipfile.ZipFile(zip_path, "r").extractall()
