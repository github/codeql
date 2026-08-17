---
category: deprecated
---
* The guard-reasoning member predicates of `ControlFlow::ConditionGuardNode` (`ensures`, `ensuresLeq`, `ensuresEq`, `ensuresNeq` and `dominates`) have been deprecated. Use the `Guard` class and the `guardEnsures`, `guardEnsuresEq`, `guardEnsuresNeq` and `guardEnsuresLeq` predicates from `semmle.go.controlflow.Guards` instead. The `ConditionGuardNode` class itself remains, since it is part of the control-flow graph.
