# Improvements to JavaScript analysis

## General improvements


## New queries

| **Query**                                                                       | **Tags**                                                          | **Purpose**                                                                                                                                                                            |
|---------------------------------------------------------------------------------|-------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|


## Changes to existing queries

| **Query**                      | **Expected impact**          | **Change**                                                                |
|--------------------------------|------------------------------|---------------------------------------------------------------------------|
| Misspelled variable name (`js/misspelled-variable-name`) | Message changed | The message for this query now correctly identifies the misspelled variable in additional cases. |
| Uncontrolled data used in path expression (`js/path-injection`) | More results | This query now recognizes additional file system calls. |
| Uncontrolled command line (`js/command-line-injection`) | More results | This query now recognizes additional command execution calls. |

## Changes to libraries

* Added data flow for `Map` and `Set`, and added matching type-tracking steps that can accessed using the `CollectionsTypeTracking` module.
