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

    finally:
        await conn.close()

async def test_connection_pool():
    pool = await asyncpg.create_pool()

    try:
        await pool.copy_from_query("sql", output="filepath")  # $ getSql="sql" getAPathArgument="filepath"
        await pool.copy_from_query("sql", "arg1", "arg2", output="filepath")  # $ getSql="sql" getAPathArgument="filepath"
        await pool.copy_from_table("table", output="filepath")  # $ getAPathArgument="filepath"
        await pool.copy_to_table("table", source="filepath")  # $ getAPathArgument="filepath"

    finally:
        await pool.close()
