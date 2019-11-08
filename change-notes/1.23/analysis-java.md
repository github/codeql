# Improvements to Java analysis

The following changes in version 1.23 affect Java analysis in all applications.

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Continue statement that does not continue (`java/continue-in-false-loop`) | correctness | Finds `continue` statements in `do { ... } while (false)` loops. |

## Changes to existing queries

| **Query**                    | **Expected impact**    | **Change**                        |
|------------------------------|------------------------|-----------------------------------|
| Dereferenced variable may be null (`java/dereferenced-value-may-be-null`) | Fewer false positives | Certain indirect null guards involving two auxiliary variables known to be equal can now be detected. |
| Non-synchronized override of synchronized method (`java/non-sync-override`) | Fewer false positives | Results are now only reported if the immediately overridden method is synchronized. |
| Query built from user-controlled sources (`java/sql-injection`) | More results | The query now identifies arguments to `Statement.executeLargeUpdate` and `Connection.prepareCall` as SQL expressions sinks. |
| Query built from local-user-controlled sources (`java/sql-injection-local`) | More results | The query now identifies arguments to `Statement.executeLargeUpdate` and `Connection.prepareCall` as SQL expressions sinks. |
| Query built without neutralizing special characters (`java/concatenated-sql-query`) | More results | The query now identifies arguments to `Statement.executeLargeUpdate` and `Connection.prepareCall` as SQL expressions sinks. |
| Useless comparison test (`java/constant-comparison`) | Fewer false positives | Additional overflow check patterns are now recognized and no longer reported. |

## Changes to QL libraries

* The data-flow library has been extended with a new feature to aid debugging.
  Instead of specifying `isSink(Node n) { any() }` on a configuration to
  explore the possible flow from a source, it is recommended to use the new
  `Configuration::hasPartialFlow` predicate, as this gives a more complete
  picture of the partial flow paths from a given source. The feature is
  disabled by default and can be enabled for individual configurations by
  overriding `int explorationLimit()`.
