# Improvements to Java analysis

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|

## Changes to QL libraries

* The `Guards` library has been extended to account for method calls that check
  conditions by conditionally throwing an exception. This includes the
  `checkArgument` and `checkState` methods in
  `com.google.common.base.Preconditions`, the `isTrue` and `validState` methods
  in `org.apache.commons.lang3.Validate`, as well as any similar custom
  methods. This means that more guards are recognized yielding precision
  improvements in a number of queries including `java/index-out-of-bounds`,
  `java/dereferenced-value-may-be-null`, and `java/useless-null-check`.


