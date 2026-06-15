from fastapi import FastAPI, Depends

app = FastAPI()

class FileHandler:
    def get_data(self, filepath: str):
        with open(filepath, "r") as f: # $ Alert
            return f.readline()

file_handler = None

def init_file_handler():
    global file_handler
    file_handler = FileHandler()

@app.get("/file/")
async def read_item(path: str): # $ Source
    if file_handler is None:
        init_file_handler()
    return file_handler.get_data(path)

def init_file_handler():
    return FileHandler()

@app.get("/file2/", dependencies=[Depends(init_file_handler)])
async def read_item(path: str, file_handler: FileHandler = Depends()): # $ Source
    return file_handler.get_data(path)


@app.get("/file3/", dependencies=[Depends(init_file_handler)])
async def read_item(path: str): # $ Source
    return file_handler.get_data(path)


@app.on_event("startup")
def init_file_handler():    
    app.state.file_handler1 = FileHandler()
    app.state.file_handler2 = FileHandler()

def get_data_source():
    return app.state.file_handler1

@app.get("/file4/")
async def read_item(path: str, data_source=Depends(get_data_source)): # $ MISSING: Source  
    return data_source.get_data(path)   
    
@app.get("/file5/", dependencies=[Depends(init_file_handler)])
async def read_item(path: str): # $ Source
    return app.state.file_handler2.get_data(path)
