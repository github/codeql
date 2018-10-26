# Improvements to C# analysis

## General improvements

* The control flow graph construction now takes simple Boolean conditions on local scope variables into account. For example, in `if (b) x = 0; if (b) x = 1;`, the control flow graph will reflect that taking the `true` (resp. `false`) branch in the first condition implies taking the same branch in the second condition. In effect, the first assignment to `x` will now be identified as being dead.

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| *@name of query (Query ID)* | *Tags*    |*Aim of the new query and whether it is enabled by default or not*  |

## Changes to existing queries

| Inconsistent lock sequence (`cs/inconsistent-lock-sequence`) | More results | This query now finds inconsistent lock sequences globally across calls. |

| *@name of query (Query ID)*| *Impact on results*    | *How/why the query has changed*                                  |


## Changes to QL libraries
