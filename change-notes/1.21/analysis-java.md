# Improvements to Java analysis

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Implicit conversion from array to string (`java/print-array`) | Fewer false positive results | Results in slf4j logging calls are no longer reported as slf4j supports array printing. |
| Result of multiplication cast to wider type (`java/integer-multiplication-cast-to-long`) | Fewer false positive results | Range analysis is now used to exclude results involving multiplication of small values that cannot overflow. |

## Changes to QL libraries

* The `Guards` library has been extended to account for method calls that check
  conditions by conditionally throwing an exception. This includes the
  `checkArgument` and `checkState` methods in
  `com.google.common.base.Preconditions`, the `isTrue` and `validState` methods
  in `org.apache.commons.lang3.Validate`, as well as any similar custom
  methods. This means that more guards are recognized yielding precision
  improvements in a number of queries including `java/index-out-of-bounds`,
  `java/dereferenced-value-may-be-null`, and `java/useless-null-check`.
* The default sanitizer in taint tracking has been made more precise. The
  sanitizer works by looking for guards that inspect tainted strings, and it
  used to work at the level of individual variables. This has been changed to
  use the `Guards` library, such that only guarded variable accesses are
  sanitized. This may give additional results in the security queries.
* Spring framework support is enhanced by taking into account additional
  annotations that indicate remote user input. This affects all security
  queries, which may yield additional results.
