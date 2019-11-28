# Improvements to JavaScript analysis

## General improvements


## New queries

| **Query**                                                                 | **Tags**                                                          | **Purpose**                                                                                                                                                                            |
|---------------------------------------------------------------------------|-------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|


## Changes to existing queries

| **Query**                      | **Expected impact**          | **Change**                                                                |
|--------------------------------|------------------------------|---------------------------------------------------------------------------|
| Clear-text logging of sensitive information (`js/clear-text-logging`) | More results | More results involving `process.env` and indirect calls to logging methods are recognized. |

## Changes to libraries

* The predicates `RegExpTerm.getSuccessor` and `RegExpTerm.getPredecessor` have been changed to reflect textual, not operational, matching order. This only makes a difference in lookbehind assertions, which are operationally matched backwards. Previously, `getSuccessor` would mimick this, so in an assertion `(?<=ab)` the term `b` would be considered the predecessor, not the successor, of `a`. Textually, however, `a` is still matched before `b`, and this is the order we now follow.
