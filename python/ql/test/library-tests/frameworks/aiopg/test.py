import aiopg

# Only a cursor can execute sql.
async def test_cursor():
    # Create connection directly
    conn = await aiopg.connect()
    cur = await conn.cursor()
    await cur.execute("sql")  # $ getSql="sql" constructedSql="sql"

    # Create connection via pool
    async with aiopg.create_pool() as pool:
        # Create Cursor via Connection
        async with pool.acquire() as conn:
            cur = await conn.cursor()
            await cur.execute("sql")  # $ getSql="sql" constructedSql="sql"

        # Create Cursor directly
        async with pool.cursor() as cur:
            await cur.execute("sql")  # $ getSql="sql" constructedSql="sql"
