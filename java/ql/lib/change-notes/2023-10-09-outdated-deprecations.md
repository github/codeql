---
category: minorAnalysis
---
* Deleted the deprecated `isBarrierGuard` predicate from the dataflow library and its uses, use `isBarrier` and the `BarrierGuard` module instead.
* Deleted the deprecated `getAValue` predicate from the `Annotation` class.
* Deleted the deprecated alias `FloatingPointLiteral`, use `FloatLiteral` instead.
* Deleted the deprecated `getASuppressedWarningLiteral` predicate from the `SuppressWarningsAnnotation` class.
* Deleted the deprecated `getATargetExpression` predicate form the `TargetAnnotation` class.
* Deleted the deprecated `getRetentionPolicyExpression` predicate from the `RetentionAnnotation` class.
* Deleted the deprecated `conditionCheck` predicate from `Preconditions.qll`.
* Deleted the deprecated `semmle.code.java.security.performance` folder, use `semmle.code.java.security.regexp` instead.
* Deleted the deprecated `ExternalAPI` class from `ExternalApi.qll`, use `ExternalApi` instead.
