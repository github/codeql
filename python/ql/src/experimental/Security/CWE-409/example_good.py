import zipfile


def safeUnzip(zipFileName):
    '''
    safeUnzip reads each file inside the zipfile 1 MB by 1 MB
    and during extraction or reading of these files it checks the total decompressed size
    doesn't exceed the SIZE_THRESHOLD
    '''
    buffer_size = 1024 * 1024 * 1  # 1 MB
    total_size = 0
    SIZE_THRESHOLD = 1024 * 1024 * 10  # 10 MB
    with zipfile.ZipFile(zipFileName) as myzip:
        for fileinfo in myzip.infolist():
            with myzip.open(fileinfo.filename, mode="r") as myfile:
                content = b''
                chunk = myfile.read(buffer_size)
                total_size += buffer_size
                if total_size > SIZE_THRESHOLD:
                    print("Bomb detected")
                    return False  # it isn't a successful extract or read
                content += chunk
                # reading next bytes of uncompressed data
                while chunk:
                    chunk = myfile.read(buffer_size)
                    total_size += buffer_size
                    if total_size > SIZE_THRESHOLD:
                        print("Bomb detected")
                        return False  # it isn't a successful extract or read
                    content += chunk

                # An example of extracting or reading each decompressed file here
                print(bytes.decode(content, 'utf-8'))
    return True  # it is a successful extract or read
