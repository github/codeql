import clickhouse_driver


SQL = "SOME SQL"


# Normal operation
client = clickhouse_driver.client.Client("localhost")

client.execute(SQL) # $ getSql=SQL
client.execute(query=SQL) # $ getSql=SQL

client.execute_with_progress(SQL) # $ getSql=SQL
client.execute_with_progress(query=SQL) # $ getSql=SQL

client.execute_iter(SQL) # $ getSql=SQL
client.execute_iter(query=SQL) # $ getSql=SQL


# commonly used alias
client = clickhouse_driver.Client("localhost")
client.execute(SQL) # $ getSql=SQL


# Using PEP249 interface
conn = clickhouse_driver.connect('clickhouse://localhost')
cursor = conn.cursor()
cursor.execute(SQL) # $ getSql=SQL


# Using custom client
#
# examples from real world code
# https://github.com/Altinity/clickhouse-mysql-data-reader/blob/3b1b7088751b05e5bbf45890c5949b58208c2343/clickhouse_mysql/dbclient/chclient.py#L10
# https://github.com/Felixoid/clickhouse-plantuml/blob/d8b2ba7d164a836770ec21f5e4035dfb04c41d9c/clickhouse_plantuml/client.py#L9


class MyClient(clickhouse_driver.Client):
    pass


MyClient("localhost").execute(SQL) # $ getSql=SQL
