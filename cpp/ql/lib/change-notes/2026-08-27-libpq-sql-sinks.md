---
category: minorAnalysis
---
* Added the PostgreSQL libpq query-execution functions (`PQexec`, `PQexecParams`, `PQprepare`, and their asynchronous `PQsendQuery`/`PQsendQueryParams`/`PQsendPrepare` counterparts) as `sql-injection` sinks, so the "Uncontrolled data used in SQL query" query flags tainted data reaching their command/query arguments.
