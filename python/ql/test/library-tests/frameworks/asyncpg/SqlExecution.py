import asyncio
import asyncpg

async def test_connection():
    conn = await asyncpg.connect()

    try:
        await conn.copy_from_query("sql", output="filepath")  # $ MISSING: getSql="sql" getAPathArgument="filepath"
        await conn.execute("sql")  # $ MISSING: getSql="sql"
        await conn.executemany("sql")  # $ MISSING: getSql="sql"
        await conn.fetch("sql")  # $ MISSING: getSql="sql"
        await conn.fetchrow("sql")  # $ MISSING: getSql="sql"
        await conn.fetchval("sql")  # $ MISSING: getSql="sql"

    finally:
        await conn.close()


async def test_prepared_statement():
    conn = await asyncpg.connect()

    try:
        pstmt = await conn.prepare('psql')
        pstmt.executemany()  # $ MISSING: getSql="psql"
        pstmt.fetch()  # $ MISSING: getSql="psql"
        pstmt.fetchrow()  # $ MISSING: getSql="psql"
        pstmt.fetchval()  # $ MISSING: getSql="psql"

    finally:
        await conn.close()

# The sql statement is executed when the `CursorFactory` (obtained by e.g. `conn.cursor()`) is awaited.
# See https://magicstack.github.io/asyncpg/current/api/index.html#asyncpg.cursor.CursorFactory
async def test_cursor():
    conn = await asyncpg.connect()

    try:
        async with conn.transaction():
            cursor = await conn.cursor("sql")  # $ MISSING: getSql="sql"
            await cursor.fetch()

            pstmt = await conn.prepare('psql')
            pcursor = await pstmt.cursor()  # $ MISSING: getSql="psql"
            await pcursor.fetch()

            async for record in conn.cursor("sql"):  # $ MISSING: getSql="sql"
                pass

            async for record in pstmt.cursor():  # $ MISSING: getSql="psql"
                pass

            cursor_factory = conn.cursor("sql")
            cursor = await cursor_factory  # $ MISSING: getSql="sql"

            pcursor_factory = pstmt.cursor()
            pcursor = await pcursor_factory  # $ MISSING: getSql="psql"

    finally:
        await conn.close()

async def test_connection_pool():
    pool = await asyncpg.create_pool()

    try:
        await pool.copy_from_query("sql", output="filepath")  # $ MISSING: getSql="sql" getAPathArgument="filepath"
        await pool.execute("sql")  # $ MISSING: getSql="sql"
        await pool.executemany("sql")  # $ MISSING: getSql="sql"
        await pool.fetch("sql")  # $ MISSING: getSql="sql"
        await pool.fetchrow("sql")  # $ MISSING: getSql="sql"
        await pool.fetchval("sql")  # $ MISSING: getSql="sql"

        async with pool.acquire() as conn:
            await conn.execute("sql")  # $ MISSING: getSql="sql"

        conn = await pool.acquire()
        try:
            await conn.fetch("sql")  # $ MISSING: getSql="sql"
        finally:
            await pool.release(conn)

    finally:
        await pool.close()

    async with asyncpg.create_pool() as pool:
        await pool.execute("sql")  # $ MISSING: getSql="sql"

        async with pool.acquire() as conn:
            await conn.execute("sql")  # $ MISSING: getSql="sql"

        conn = await pool.acquire()
        try:
            await conn.fetch("sql")  # $ MISSING: getSql="sql"
        finally:
            await pool.release(conn)
