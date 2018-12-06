# Improvements to JavaScript analysis

## General improvements

## New queries

| **Query**                                     | **Tags**                                             | **Purpose**                                                                                                                                                                 |
|-----------------------------------------------|------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Useless comparison test | correctness | Highlights code that is unreachable due to a numeric comparison that is always true or always false. |


## Changes to existing queries

| **Query**                                  | **Expected impact**          | **Change**                                                                   |
|--------------------------------------------|------------------------------|------------------------------------------------------------------------------|
| Client-side cross-site scripting           | More results                 | This rule now recognizes WinJS functions that are vulnerable to HTML injection. |
| Unused variable, import, function or class | Fewer false-positive results | This rule now flags fewer variables that are implictly used by JSX elements. |

## Changes to QL libraries
