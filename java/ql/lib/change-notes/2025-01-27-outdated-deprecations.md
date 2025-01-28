---
category: breaking
---
* Deleted the deprecated `isLValue` and `isRValue` predicates from the `VarAccess` class, use `isVarWrite` and `isVarRead` respectively instead.
* Deleted the deprecated `getRhs` predicate from the `VarWrite` class, use `getASource` instead.
* Deleted the deprecated `LValue` and `RValue` classes, use `VarWrite` and `VarRead` respectively instead.
* Deleted a lot of deprecated classes ending in "*Access", use the corresponding "*Call" classes instead.
* Deleted a lot of deprecated predicates ending in "*Access", use the corresponding "*Call" predicates instead.
* Deleted the deprecated `EnvInput` and `DatabaseInput` classes from `FlowSources.qll`, use the threat models feature instead.
* Deleted some deprecated API predicates from `SensitiveApi.qll`, use the Sink classes from that file instead.

