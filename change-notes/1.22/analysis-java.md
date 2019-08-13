# Improvements to Java analysis

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Equals method does not inspect argument type (`java/unchecked-cast-in-equals`) | Fewer false positive and more true positive results | Precision has been improved by doing a bit of inter-procedural analysis and relying less on ad-hoc method names. |
| Uncontrolled data in arithmetic expression (`java/uncontrolled-arithmetic`) | Fewer false positive results | Precision has been improved in several ways, in particular, by better detection of guards along the data-flow path. |
| User-controlled data in arithmetic expression (`java/tainted-arithmetic`) | Fewer false positive results | Precision has been improved in several ways, in particular, by better detection of guards along the data-flow path. |

## Changes to QL libraries

* The virtual dispatch library has been updated to give more precise dispatch
  targets for `Object.toString()` calls. This affects all security queries and
  removes false positives that arose from paths through impossible `toString()`
  calls.

