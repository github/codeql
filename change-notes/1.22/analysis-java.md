# Improvements to Java analysis

The following changes in version 1.22 affect Java analysis in all applications.

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Equals method does not inspect argument type (`java/unchecked-cast-in-equals`) | Fewer false positive and more true positive results | Precision has been improved by doing a bit of inter-procedural analysis and relying less on ad-hoc method names. |
| Uncontrolled data in arithmetic expression (`java/uncontrolled-arithmetic`) | Fewer false positive results | Precision has been improved in several ways, in particular, by better detection of guards along the data-flow path. |
| Uncontrolled data used in path expression (`java/path-injection`) | Fewer false positive results | The query no longer reports results guarded by `!var.contains("..")`. |
| User-controlled data in arithmetic expression (`java/tainted-arithmetic`) | Fewer false positive results | Precision has been improved in several ways, in particular, by better detection of guards along the data-flow path. |

## Changes to QL libraries

* The virtual dispatch library has been updated to give more precise dispatch
  targets for `Object.toString()` calls. This affects all security queries and
  removes false positive results that arose from paths through impossible `toString()`
  calls.
* The library `VCS.qll` and all queries that imported it have been removed.
* The second copy of the interprocedural `TaintTracking` library has been
  renamed from `TaintTracking::Configuration2` to
  `TaintTracking2::Configuration`, and the old name is now deprecated. Import
  `semmle.code.java.dataflow.TaintTracking2` to access the new name.
* The data-flow library now makes it easier to specify barriers/sanitizers
  arising from guards by overriding the predicate
  `isBarrierGuard`/`isSanitizerGuard` on data-flow and taint-tracking
  configurations respectively.
* The possibility of specifying barrier edges using
  `isBarrierEdge`/`isSanitizerEdge` in data-flow and taint-tracking
  configurations has been replaced with the option of specifying in- and
  out-barriers on nodes by overriding `isBarrierIn`/`isSanitizerIn` and
  `isBarrierOut`/`isSanitizerOut`. This should be simpler to use effectively,
  as it does not require knowledge about the actual edges used internally by
  the library.
