import psycopg

conn = psycopg.connect(...)
conn.execute("some sql", (42,))  # $ getSql="some sql"
cursor = conn.cursor()
cursor.execute("some sql", (42,))  # $ getSql="some sql"
cursor.executemany("some sql", [(42,)])  # $ getSql="some sql"

# as in their examples:
with psycopg.connect(...) as conn:
    conn.execute("some sql", (42,))  # $ getSql="some sql"
    with conn.cursor() as cursor:
        cursor.execute("some sql", (42,))  # $ getSql="some sql"
        cursor.executemany("some sql", [(42,)])  # $ getSql="some sql"
