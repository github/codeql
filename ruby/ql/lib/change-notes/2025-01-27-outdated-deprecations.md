---
category: breaking
---
* Deleted the deprecated `getCallNode` predicate from `API::Node`, use `asCall()` instead.
* Deleted the deprecated `getASubclass`, `getAnImmediateSubclass`, `getASuccessor`, `getAPredecessor`, `getASuccessor`, `getDepth`, and `getPath` predicates from `API::Node`. 
* Deleted the deprecated `Root`, `Use`, and `Def` classes from `ApiGraphs.qll`.
* Deleted the deprecated `Label` module from `ApiGraphs.qll`.
* Deleted the deprecated `getAUse`, `getAnImmediateUse`, `getARhs`, and `getAValueReachingRhs` predicates from `API::Node`, use `getAValueReachableFromSource`, `asSource`, `asSink`, and `getAValueReachingSink` instead.
* Deleted the deprecated `getAVariable` predicate from the `ExprNode` class, use `getVariable` instead.
* Deleted the deprecated `getAPotentialFieldAccessMethod` predicate from the `ActiveRecordModelClass` class.
* Deleted the deprecated `ActiveRecordModelClassMethodCall` class from `ActiveRecord.qll`, use `ActiveRecordModelClass.getClassNode().trackModule().getMethod()` instead.
* Deleted the deprecated `PotentiallyUnsafeSqlExecutingMethodCall` class from `ActiveRecord.qll`, use the `SqlExecution` concept instead.
* Deleted the deprecated `ModelClass` and `ModelInstance` classes from `ActiveResource.qll`, use `ModelClassNode` and `ModelClassNode.getAnInstanceReference()` instead.
* Deleted the deprecated `Collection` class from `ActiveResource.qll`, use `CollectionSource` instead.
* Deleted the deprecated `ServiceInstantiation` and `ClientInstantiation` classes from `Twirp.qll`.
* Deleted a lot of deprecated dataflow modules from "*Query.qll" files.
* Deleted the old deprecated TypeTracking library.
