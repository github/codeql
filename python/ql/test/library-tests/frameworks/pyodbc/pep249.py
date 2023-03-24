import pyodbc

cnxn = pyodbc.connect('DSN=test;PWD=password')

cursor = cnxn.cursor()
cursor.execute("some sql")  # $ getSql="some sql"
