---
category: fix
---
* Fixed a bug in the `DataFlow::BarrierGuard<...>::getABarrierNode` predicate which caused the predicate to return `DataFlow::Node`s with incorrect indirections. If you use `getABarrierNode` to implement barriers in a dataflow/taint-tracking query it may result in more query results. You can use `DataFlow::BarrierGuard<...>::getAnIndirectBarrierNode` to remove those query results.