# Improvements to JavaScript analysis

## General improvements

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| *@name of query (Query ID)* | *Tags*    |*Aim of the new query and whether it is enabled by default or not*  |

## Changes to existing queries

| **Query**                      | **Expected impact**        | **Change**                                   |
|--------------------------------|----------------------------|----------------------------------------------|
| Regular expression injection | Fewer false-positive results | This rule now identifies calls to `String.prototype.search` with more precision. |
| Unbound event handler receiver | Fewer false-positive results | This rule now recognizes additional ways class methods can be bound. |


## Changes to QL libraries
