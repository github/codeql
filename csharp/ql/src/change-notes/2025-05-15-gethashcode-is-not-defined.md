---
category: minorAnalysis
---
* The precision of the query `cs/gethashcode-is-not-defined` has been improved (false negative reduction). Calls to more methods (and indexers) that rely on the invariant `e1.Equals(e2)` implies `e1.GetHashCode() == e2.GetHashCode()` are taken into account.
