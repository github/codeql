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


        ### test of threat-model sources
        row = cursor.fetchone() # $ threatModelSource[database]=cursor.fetchone()
        rows_many = cursor.fetchmany(10) # $ threatModelSource[database]=cursor.fetchmany(..)
        rows_all = cursor.fetchall() # $ threatModelSource[database]=cursor.fetchall()

        ensure_tainted(
            row[0],  # $ tainted
            rows_many[0][0],  # $ tainted
            rows_all[0][0],  # $ tainted

            # pretending we created cursor to return dictionary results
            row["column"],  # $ tainted
            rows_many[0]["column"],  # $ tainted
            rows_all[0]["column"],  # $ tainted
        )
        for row in rows_many:
            ensure_tainted(row[0], row["column"]) # $ tainted
        for row in rows_all:
            ensure_tainted(row[0], row["column"]) # tainted
