---
category: feature
---
* The predicates of the CodeQL class `Annotation` have been improved:
  * Convenience value type specific predicates have been added, such as `getEnumConstantValue(string)` or `getStringValue(string)`.
  * Convenience predicates for elements with array values have been added, such as `getAnEnumConstantArrayValue(string)`. While the behavior of the existing predicates has not changed, usage of them should be reviewed (or replaced with the newly added predicate) to make sure they work correctly for elements with array values.
  * Some internal CodeQL usage of the `Annotation` predicates has been adjusted and corrected; this might affect the results of some queries.
* New predicates have been added to the CodeQL class `Annotatable` to support getting declared and associated annotations. As part of that, `hasAnnotation()` has been changed to also consider inherited annotations, to be consistent with `hasAnnotation(string, string)` and `getAnAnnotation()`. The newly added predicate `hasDeclaredAnnotation()` can be used as replacement for the old functionality.
* New predicates have been added to the CodeQL class `AnnotationType` to simplify getting information about usage of JDK meta-annotations, such as `@Retention`.
