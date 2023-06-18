import io
from fastapi import FastAPI

app = FastAPI()


def bomb(bomb_input):
    import shutil
    shutil.unpack_archive(bomb_input)
    import lzma
    lzma.open(bomb_input)
    lzma.LZMAFile(bomb_input).read()
    import gzip
    gzip.open(bomb_input)
    gzip.GzipFile(bomb_input).read()

    with gzip.open(bomb_input, 'rb') as ip:
        with io.TextIOWrapper(ip, encoding='utf-8') as decoder:
            content = decoder.read()
            print(content)

    import bz2
    bz2.open(bomb_input)
    bz2.BZ2File(bomb_input).read()

    import pandas
    pandas.read_csv(filepath_or_buffer=bomb_input)

    pandas.read_table(bomb_input, compression='gzip')
    pandas.read_xml(bomb_input, compression='gzip')

    pandas.read_csv(filepath_or_buffer=bomb_input, compression='gzip')
    pandas.read_json(bomb_input, compression='gzip')
    pandas.read_sas(bomb_input, compression='gzip')
    pandas.read_stata(filepath_or_buffer=bomb_input, compression='gzip')
    pandas.read_table(bomb_input, compression='gzip')
    pandas.read_xml(path_or_buffer=bomb_input, compression='gzip')

    # no compression no DOS
    pandas.read_table(bomb_input, compression='tar')
    pandas.read_xml(bomb_input, compression='tar')

    pandas.read_csv(filepath_or_buffer=bomb_input, compression='tar')
    pandas.read_json(bomb_input, compression='tar')
    pandas.read_sas(bomb_input, compression='tar')
    pandas.read_stata(filepath_or_buffer=bomb_input, compression='tar')
    pandas.read_table(bomb_input, compression='tar')
    pandas.read_xml(path_or_buffer=bomb_input, compression='tar')


@app.post("/bomb")
async def bombs(bomb_input):
    bomb(bomb_input)
    return {"message": "non-async"}
