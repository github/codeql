---
category: deprecated
---
* The predicate `Annotation.getAValue()` has been deprecated because it might lead to obtaining the value of the wrong annotation element by accident. `getValue(string)` (or one of the value type specific predicates) should be used to explicitly specify the name of the annotation element.
* The predicate `Annotation.getAValue(string)` has been renamed to `getAnArrayValue(string)`.
* The predicate `SuppressWarningsAnnotation.getASuppressedWarningLiteral()` has been deprecated because it unnecessarily restricts the result type; `getASuppressedWarning()` should be used instead.
* The predicates `TargetAnnotation.getATargetExpression()` and `RetentionAnnotation.getRetentionPolicyExpression()` have been deprecated because getting the enum constant read expression is rarely useful, instead the corresponding predicates for getting the name of the referenced enum constants should be used.
