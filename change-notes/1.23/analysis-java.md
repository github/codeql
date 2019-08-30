# Improvements to Java analysis

The following changes in version 1.23 affect Java analysis in all applications.

## Changes to existing queries

| **Query**                    | **Expected impact**    | **Change**                        |
|------------------------------|------------------------|-----------------------------------|
| Query built from user-controlled sources (`java/sql-injection`) | More results | The query now identifies arguments to `Statement.executeLargeUpdate` and `Connection.prepareCall` as SQL expressions sinks. |
| Query built from local-user-controlled sources (`java/sql-injection-local`) | More results | The query now identifies arguments to `Statement.executeLargeUpdate` and `Connection.prepareCall` as SQL expressions sinks. |
| Query built without neutralizing special characters (`java/concatenated-sql-query`) | More results | The query now identifies arguments to `Statement.executeLargeUpdate` and `Connection.prepareCall` as SQL expressions sinks. |
