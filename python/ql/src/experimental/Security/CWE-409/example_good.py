import zipfile


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
