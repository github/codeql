# Improvements to C# analysis

## General improvements

* The control flow graph construction now takes simple Boolean conditions on local scope variables into account. For example, in `if (b) x = 0; if (b) x = 1;`, the control flow graph will reflect that taking the `true` (resp. `false`) branch in the first condition implies taking the same branch in the second condition. In effect, the first assignment to `x` will now be identified as being dead.

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Using a package with a known vulnerability (cs/use-of-vulnerable-package) | security, external/cwe/cwe-937 | Finds project build files that import packages with known vulnerabilities. This is included by default. |


## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| *@name of query (Query ID)*| *Impact on results*    | *How/why the query has changed*                                  |


## Changes to QL libraries
