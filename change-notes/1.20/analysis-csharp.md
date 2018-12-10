# Improvements to C# analysis

## General improvements

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|

## Changes to existing queries

| *@name of query (Query ID)*  | *Impact on results*    | *How/why the query has changed*   |
|------------------------------|------------------------|-----------------------------------|
| Dereferenced variable is always null (cs/dereferenced-value-is-always-null) | Improved results | The query has been rewritten from scratch, and the analysis is now based on static single assignment (SSA) forms. The query is now enabled by default in LGTM. |
| Dereferenced variable may be null (cs/dereferenced-value-may-be-null) | Improved results | The query has been rewritten from scratch, and the analysis is now based on static single assignment (SSA) forms. The query is now enabled by default in LGTM. |
| Off-by-one comparison against container length (cs/index-out-of-bounds) | Fewer false positives | Results have been removed when there are additional guards on the index. |
| Potentially dangerous use of non-short-circuit logic (cs/non-short-circuit) | No results | The query has been removed as it has been superseded by the queries Dereferenced variable is always null (cs/dereferenced-value-is-always-null) and Dereferenced variable may be null (cs/dereferenced-value-may-be-null). |

## Changes to code extraction

## Changes to QL libraries

## Changes to the autobuilder
