# Improvements to Java analysis

The following changes in version 1.24 affect Java analysis in all applications.

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|

## Changes to existing queries

| **Query**                    | **Expected impact**    | **Change**                        |
|------------------------------|------------------------|-----------------------------------|
| Expression always evaluates to the same value (`java/evaluation-to-constant`) | Fewer false positives | Expressions of the form `0 * x` are usually intended and no longer reported. |

## Changes to libraries

* Identification of test classes have been improved. Previously, one of the
  match conditions would classify any class with a name containing the string
  "Test" as a test class, but now this matching has been replaced with one that
  looks for the occurrence of actual unit-test annotations. This affects the
  general file classification mechanism and thus suppression of alerts, and
  also any security queries using taint tracking, as test classes act as
  default barriers stopping taint flow.

