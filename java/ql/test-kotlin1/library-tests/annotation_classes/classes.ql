import java

from ClassOrInterface x
where x.fromSource()
select x, x.getPrimaryQlClasses()

query predicate annotationDeclarations(AnnotationType at, AnnotationElement ae) {
  at.fromSource() and
  at.getAnAnnotationElement() = ae
}

query predicate annotations(Annotation a, Element e, AnnotationType at) {
  at.fromSource() and
  a.getAnnotatedElement() = e and
  at = a.getType()
}

query predicate annotationValues(Annotation a, Expr v) {
  a.getValue(_) = v and v.getFile().isSourceFile()
}
