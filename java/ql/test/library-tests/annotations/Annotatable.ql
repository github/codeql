import java

class RelevantAnnotatable extends Annotatable {
  RelevantAnnotatable() {
    this.getCompilationUnit().hasName("Annotatable") and this.getCompilationUnit().fromSource()
  }
}

query Annotation declaredAnnotation(RelevantAnnotatable a) { result = a.getADeclaredAnnotation() }

/** Note: Only has the annotations as result which are not also considered _declared_. */
query Annotation annotationAdditional(RelevantAnnotatable a) {
  result = a.getAnAnnotation() and not result = a.getADeclaredAnnotation()
}

/** Sanity check to verify that `getADeclaredAnnotation()` is a subset of `getAnAnnotation()` */
query Annotation bugAnnotationAdditional(RelevantAnnotatable a) {
  result = a.getADeclaredAnnotation() and not result = a.getAnAnnotation()
}

/** Note: Only has the annotations as result which are not part of `getAnAnnotation()`. */
query Annotation associatedAnnotationAdditional(RelevantAnnotatable a) {
  result = a.getAnAssociatedAnnotation() and not result = a.getAnAnnotation()
}

/**
 * Covers all results of `getAnAssociatedAnnotation()` which are not also a result of `getAnAnnotation()`.
 * This should only be the case for a base class using an inheritable annotation `A` and a subclass which
 * has an annotation `CA` of the container type of `A`. In that case `A` is not considered _associated_
 * and the _indirect_ annotations from `CA` are considered instead.
 */
query Annotation associatedAnnotationNotInherited(RelevantAnnotatable a) {
  result = a.getAnAnnotation() and not result = a.getAnAssociatedAnnotation()
}
