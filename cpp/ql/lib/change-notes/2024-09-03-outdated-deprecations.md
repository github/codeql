---
category: breaking
---
* Deleted many deprecated taint-tracking configurations based on `TaintTracking::Configuration`. 
* Deleted many deprecated dataflow configurations based on `DataFlow::Configuration`. 
* Deleted the deprecated `hasQualifiedName` and `isDefined` predicates from the `Declaration` class, use `hasGlobalName` and `hasDefinition` respectively instead.
* Deleted the `getFullSignature` predicate from the `Function` class, use `getIdentityString(Declaration)` from `semmle.code.cpp.Print` instead.
* Deleted the deprecated `freeCall` predicate from `Alloc.qll`. Use `DeallocationExpr` instead.
* Deleted the deprecated `explorationLimit` predicate from `DataFlow::Configuration`, use `FlowExploration<explorationLimit>` instead.
* Deleted the deprecated `getFieldExpr` predicate from `ClassAggregateLiteral`, use `getAFieldExpr` instead.
* Deleted the deprecated `getElementExpr` predicate from `ArrayOrVectorAggregateLiteral`, use `getAnElementExpr` instead.
