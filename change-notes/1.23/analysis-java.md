# Improvements to Java analysis

The following changes in version 1.23 affect Java analysis in all applications.

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Continue statement that does not continue (`java/continue-in-false-loop`) | correctness | Finds `continue` statements in `do { ... } while (false)` loops. Results are shown on LGTM by default. |
| Disabled Netty HTTP header validation (`java/netty-http-response-splitting`) | security, external/cwe/cwe-113 | Finds response-splitting vulnerabilities due to Netty HTTP header validation being disabled. Results are shown on LGTM by default. |

## Changes to existing queries

| **Query**                    | **Expected impact**    | **Change**                        |
|------------------------------|------------------------|-----------------------------------|
| Dereferenced variable may be null (`java/dereferenced-value-may-be-null`) | Fewer false positive results | Additional indirect null guards are detected, where two auxiliary variables are known to be equal. |
| Non-synchronized override of synchronized method (`java/non-sync-override`) | Fewer false positive results | Results are now only reported if the immediately overridden method is synchronized. |
| Query built from local-user-controlled sources (`java/sql-injection-local`) | More results | The query now identifies arguments to `Statement.executeLargeUpdate` and `Connection.prepareCall` as sinks for SQL expressions. |
| Query built from user-controlled sources (`java/sql-injection`) | More results | The query now identifies arguments to `Statement.executeLargeUpdate` and `Connection.prepareCall` as sinks for SQL expressions. |
| Query built without neutralizing special characters (`java/concatenated-sql-query`) | More results | The query now identifies arguments to `Statement.executeLargeUpdate` and `Connection.prepareCall` as sinks for SQL expressions. |
| Useless comparison test (`java/constant-comparison`) | Fewer false positive results | Additional overflow check patterns are now recognized and no longer reported. Also, a few bug fixes in the range analysis for floating-point variables gives a further reduction in false positive results. |

## Changes to libraries

The data-flow library has been extended with a new feature to aid debugging. 
Previously, to explore the possible flow from all sources you could specify `isSink(Node n) { any() }` on a configuration. 
Now you can use the new `Configuration::hasPartialFlow` predicate, 
which gives a more complete picture of the partial flow paths from a given source, including flow that doesn't reach any sink.
The feature is disabled by default and can be enabled for individual configurations by overriding `int explorationLimit()`.
