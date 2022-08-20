import aiomysql

# Only a cursor can execute sql.
async def test_cursor():
    # Create connection directly
    conn = await aiomysql.connect()
    cur = await conn.cursor()
    await cur.execute("sql")  # $ getSql="sql" constructedSql="sql"

    # Create connection via pool
    async with aiomysql.create_pool() as pool:
        # Create Cursor via Connection
        async with pool.acquire() as conn:
            async with conn.cursor() as cur:
                await cur.execute("sql")  # $ getSql="sql" constructedSql="sql"

        # Create Cursor directly
        async with pool.cursor() as cur:
            await cur.execute("sql")  # $ getSql="sql" constructedSql="sql"

    # variants using as few `async with` as possible
    pool = await aiomysql.create_pool()
    conn = await pool.acquire()
    cur = await conn.cursor()
    await cur.execute("sql")  # $ getSql="sql" constructedSql="sql"

# Test SQLAlchemy integration
from aiomysql.sa import create_engine

async def test_engine():
    engine = await create_engine()
    conn = await engine.acquire()
    await conn.execute("sql")  # $ getSql="sql" constructedSql="sql"
