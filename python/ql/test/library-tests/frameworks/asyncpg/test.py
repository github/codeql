import asyncio
import asyncpg

async def test_connection():
    conn = await asyncpg.connect()

    try:
        # The file-like object is passed in as a keyword-only argument.
        # See https://magicstack.github.io/asyncpg/current/api/index.html#asyncpg.connection.Connection.copy_from_query
        await conn.copy_from_query("sql", output="filepath")  # $ getSql="sql" getAPathArgument="filepath"
        await conn.copy_from_query("sql", "arg1", "arg2", output="filepath")  # $ getSql="sql" getAPathArgument="filepath"

        await conn.copy_from_table("table", output="filepath")  # $ getAPathArgument="filepath"
        await conn.copy_to_table("table", source="filepath")  # $ getAPathArgument="filepath"

        await conn.execute("sql")  # $ getSql="sql"
        await conn.executemany("sql")  # $ getSql="sql"
        await conn.fetch("sql")  # $ getSql="sql"
        await conn.fetchrow("sql")  # $ getSql="sql"
        await conn.fetchval("sql")  # $ getSql="sql"

    finally:
        await conn.close()


async def test_prepared_statement():
    conn = await asyncpg.connect()

    try:
        pstmt = await conn.prepare("psql")  # $ constructedSql="psql"
        pstmt.executemany()  # $ getSql="psql"
        pstmt.fetch()  # $ getSql="psql"
        pstmt.fetchrow()  # $ getSql="psql"
        pstmt.fetchval()  # $ getSql="psql"

    finally:
        await conn.close()

# The sql statement is executed when the `CursorFactory` (obtained by e.g. `conn.cursor()`) is awaited.
# See https://magicstack.github.io/asyncpg/current/api/index.html#asyncpg.cursor.CursorFactory
async def test_cursor():
    conn = await asyncpg.connect()

    try:
        async with conn.transaction():
            cursor = await conn.cursor("sql")  # $ getSql="sql" constructedSql="sql"
            await cursor.fetch()

            pstmt = await conn.prepare("psql")  # $ constructedSql="psql"
            pcursor = await pstmt.cursor()  # $ getSql="psql"
            await pcursor.fetch()

            async for record in conn.cursor("sql"):  # $ getSql="sql" constructedSql="sql"
                pass

            async for record in pstmt.cursor():  # $ getSql="psql"
                pass

            cursor_factory = conn.cursor("sql")  # $ constructedSql="sql"
            cursor = await cursor_factory  # $ getSql="sql"

            pcursor_factory = pstmt.cursor()
            pcursor = await pcursor_factory  # $ getSql="psql"

    finally:
        await conn.close()

async def test_connection_pool():
    pool = await asyncpg.create_pool()

    try:
        await pool.copy_from_query("sql", output="filepath")  # $ getSql="sql" getAPathArgument="filepath"
        await pool.copy_from_query("sql", "arg1", "arg2", output="filepath")  # $ getSql="sql" getAPathArgument="filepath"
        await pool.copy_from_table("table", output="filepath")  # $ getAPathArgument="filepath"
        await pool.copy_to_table("table", source="filepath")  # $ getAPathArgument="filepath"

        await pool.execute("sql")  # $ getSql="sql"
        await pool.executemany("sql")  # $ getSql="sql"
        await pool.fetch("sql")  # $ getSql="sql"
        await pool.fetchrow("sql")  # $ getSql="sql"
        await pool.fetchval("sql")  # $ getSql="sql"

        async with pool.acquire() as conn:
            await conn.execute("sql")  # $ getSql="sql"

        conn = await pool.acquire()
        try:
            await conn.fetch("sql")  # $ getSql="sql"
        finally:
            await pool.release(conn)

    finally:
        await pool.close()

    async with asyncpg.create_pool() as pool:
        await pool.execute("sql")  # $ getSql="sql"

        async with pool.acquire() as conn:
            await conn.execute("sql")  # $ getSql="sql"

        conn = await pool.acquire()
        try:
            await conn.fetch("sql")  # $ getSql="sql"
        finally:
            await pool.release(conn)
