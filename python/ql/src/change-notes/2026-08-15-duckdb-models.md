## Change notes

Add SQL injection models for the `duckdb` PyPI package. `duckdb` implements the
Python DB-API 2.0 (PEP 249): `duckdb.connect()`, `connection.cursor()`,
`cursor.execute()`, `cursor.executemany()` are now modeled as SQL execution
sinks, and the module-level convenience wrappers `duckdb.sql()`,
`duckdb.execute()` and `duckdb.executemany()` are additionally modeled as
`SqlExecution` calls.
