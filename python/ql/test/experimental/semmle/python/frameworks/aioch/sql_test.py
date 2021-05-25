import aioch


SQL = "SOME SQL"


async def aioch_test():
    client = aioch.Client("localhost")

    await client.execute(SQL) # $ getSql=SQL
    await client.execute(query=SQL) # $ MISSING: getSql=SQL

    await client.execute_with_progress(SQL) # $ getSql=SQL
    await client.execute_with_progress(query=SQL) # $ MISSING: getSql=SQL

    await client.execute_iter(SQL) # $ getSql=SQL
    await client.execute_iter(query=SQL) # $ MISSING: getSql=SQL


# Using custom client (this has been seen done for the blocking version in
# `clickhouse_driver` PyPI package)


class MyClient(aioch.Client):
    pass


async def test_custom_client():
    client = MyClient("localhost")
    await client.execute(SQL) # $ getSql=SQL
