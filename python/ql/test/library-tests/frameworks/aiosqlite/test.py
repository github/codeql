import aiosqlite

# see https://pypi.org/project/aiosqlite/

async def test():
    db = await aiosqlite.connect(...)

    await db.execute("sql") # $ getSql="sql" constructedSql="sql"
    await db.execute(sql="sql") # $ getSql="sql" constructedSql="sql"

    cursor = await db.cursor()
    cursor.execute("sql") # $ constructedSql="sql"

    cursor = await db.execute("sql") # $ getSql="sql" constructedSql="sql"
    cursor.execute("sql") # $ constructedSql="sql"

    async with aiosqlite.connect(...) as db:
        db.row_factory = aiosqlite.Row
        async with db.execute("sql") as cursor: # $ getSql="sql" constructedSql="sql"
            async for row in cursor:
                print(row['column'])

    # nonstandard
    await db.execute_insert("sql") # $ getSql="sql" constructedSql="sql"
    await db.execute_fetchall("sql") # $ getSql="sql" constructedSql="sql"
    await db.executescript("sql") # $ getSql="sql" constructedSql="sql"
    await db.executescript(sql_script="sql") # $ getSql="sql" constructedSql="sql"
