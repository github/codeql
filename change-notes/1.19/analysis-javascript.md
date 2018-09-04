# Improvements to JavaScript analysis

## General improvements

* Support for popular libraries has been improved. Consequently, queries may produce more results on code bases that use the following features:
  - file system access, for example through [fs-extra](https://github.com/jprichardson/node-fs-extra)

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| *@name of query (Query ID)* | *Tags*    |*Aim of the new query and whether it is enabled by default or not*  |

## Changes to existing queries

| **Query**                      | **Expected impact**        | **Change**                                   |
|--------------------------------|----------------------------|----------------------------------------------|
| Reflected cross-site scripting | More true-positive results | This rule now treats file names as a source. |


## Changes to QL libraries

