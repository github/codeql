from fastapi import FastAPI
from hdbcli import dbapi
from db_connection import get_conn
from db_connection import hdb_con
from db_connection import hdb_con2
from db_connection import hdb_con3
app = FastAPI()

class DatabaseConnection:

    def __init__(self):
        self._conn = dbapi.connect(address='localhost', port=30015, user='system', password='Password123')

    def get_conn(self):
        return self._conn

db_connection = DatabaseConnection()

@app.get("/unsafe1/")
async def unsafe(name: str): # $ Source
    query = "select * from users where name=" + name
    cursor = hdb_con.cursor()
    cursor.execute(query) # $ Alert
    cursor.close()

@app.get("/unsafe2/")
async def unsafe2(name: str): # $ Source
    query = "select * from users where name=" + name
    cursor = hdb_con2.cursor()
    cursor.execute(query) # $ Alert
    cursor.close()

@app.get("/unsafe3/")
async def unsafe3(name: str): # $ MISSING: Source
    query = "select * from users where name=" + name
    cursor = hdb_con3.cursor()
    cursor.execute(query) # $ MISSING: Alert
    cursor.close()

@app.get("/unsafe4/")
async def unsafe4(name: str): # $ Source
    query = "select * from users where name=" + name
    cursor = get_conn().cursor()
    cursor.execute(query) # $ Alert
    cursor.close()

@app.get("/unsafe5/")
async def unsafe5(name: str): # $ Source
    query = "select * from users where name=" + name
    cursor = db_connection.get_conn().cursor()
    cursor.execute(query) # $ Alert
    cursor.close()
