# Improvements to Java analysis

## General improvements


## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Double-checked locking is not thread-safe (`java/unsafe-double-checked-locking`) | reliability, correctness, concurrency, external/cwe/cwe-609 | Identifies wrong implementations of double-checked locking that does not use the `volatile` keyword. |
| Race condition in double-checked locking object initialization (`java/unsafe-double-checked-locking-init-order`) | reliability, correctness, concurrency, external/cwe/cwe-609 | Identifies wrong implementations of double-checked locking that performs additional initialization after exposing the constructed object. |

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Arbitrary file write during archive extraction ("Zip Slip") (`java/zipslip`) | Fewer false positive results | Results involving a sanitization step that converts a destination `Path` to a `File` are no longer reported. |
| Double-checked locking is not thread-safe (`java/unsafe-double-checked-locking`) | Fewer false positive results and more true positive results | Results that use safe publication through a `final` field are no longer reported. Results that initialize immutable types like `String` incorrectly are now reported. |
| Result of multiplication cast to wider type (`java/integer-multiplication-cast-to-long`) | Fewer results | Results involving conversions to `float` or `double` are no longer reported, as they were almost exclusively false positives. |

## Changes to QL libraries

* The deprecated library `semmle.code.java.security.DataFlow` has been removed.
  Improved data flow libraries have been available in
  `semmle.code.java.dataflow.DataFlow`,
  `semmle.code.java.dataflow.TaintTracking`, and
  `semmle.code.java.dataflow.FlowSources` since 1.16.
* Taint tracking now includes additional default data-flow steps through
  collections, maps, and iterators. This affects all security queries, which
  can report more results based on such paths.


