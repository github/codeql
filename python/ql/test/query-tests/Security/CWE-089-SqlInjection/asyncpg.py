import asyncio
import asyncpg

"""This is adapted from ql/python/ql/test/query-tests\Security\CWE-089
we now prefer to setup routing by flask
"""

from django.db import connection, models
from flask import Flask
app = Flask(__name__)

@app.route("/users/<username>")
async def show_user(username):
    conn = await asyncpg.connect()

    try:
        # The file-like object is passed in as a keyword-only argument.
        # See https://magicstack.github.io/asyncpg/current/api/index.html#asyncpg.connection.Connection.copy_from_query
        await conn.copy_from_query(username, output="filepath") # BAD
        await conn.copy_from_query(username, "arg1", "arg2", output="filepath")  # BAD

        await conn.execute(username)  # BAD
        await conn.executemany(username)  # BAD
        await conn.fetch(username)  # BAD
        await conn.fetchrow(username)  # BAD
        await conn.fetchval(username)  # BAD
        
        pstmt = await conn.prepare(username)  # BAD
        pstmt.executemany()  
        pstmt.fetch()  
        pstmt.fetchrow()
        pstmt.fetchval()

        # The sql statement is executed when the `CursorFactory` (obtained by e.g. `conn.cursor()`) is awaited.
        # See https://magicstack.github.io/asyncpg/current/api/index.html#asyncpg.cursor.CursorFactory
        async with conn.transaction():
            cursor = await conn.cursor(username) # BAD
            await cursor.fetch()

            pstmt = await conn.prepare(username) # BAD
            pcursor = await pstmt.cursor() 
            await pcursor.fetch()

            async for record in conn.cursor(username): # BAD
                pass

            cursor_factory = conn.cursor(username) # BAD
            cursor = await cursor_factory 

    finally:
        await conn.close()

    pool = await asyncpg.create_pool()

    try:
        await pool.copy_from_query(username, output="filepath")  # BAD
        await pool.copy_from_query(username, "arg1", "arg2", output="filepath") # BAD

        await pool.execute(username) # BAD
        await pool.executemany(username) # BAD
        await pool.fetch(username) # BAD
        await pool.fetchrow(username) # BAD
        await pool.fetchval(username) # BAD

        async with pool.acquire() as conn:
            await conn.execute(username) # BAD

        conn = await pool.acquire()
        try:
            await conn.fetch(username) # BAD
        finally:
            await pool.release(conn)

    finally:
        await pool.close()

    async with asyncpg.create_pool() as pool:
        await pool.execute(username) # BAD

        async with pool.acquire() as conn:
            await conn.execute(username) # BAD

        conn = await pool.acquire()
        try:
            await conn.fetch(username) # BAD
        finally:
            await pool.release(conn)
