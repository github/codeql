# Improvements to JavaScript analysis

## General improvements

* Support for popular libraries has been improved. Consequently, queries may produce more results on code bases that use the following features:
  - servers, for example [hapi](https://hapijs.com/)

## New queries

| **Query**                                     | **Tags**                                             | **Purpose**                                                                                                                                                                 |
|-----------------------------------------------|------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Useless comparison test | correctness | Highlights code that is unreachable due to a numeric comparison that is always true or always false. |


## Changes to existing queries

| **Query**                                  | **Expected impact**          | **Change**                                                                   |
|--------------------------------------------|------------------------------|------------------------------------------------------------------------------|
| Unused variable, import, function or class | Fewer false-positive results | This rule now flags fewer variables that are implictly used by JSX elements. |
|                                            |                              |                                                                              |

## Changes to QL libraries
