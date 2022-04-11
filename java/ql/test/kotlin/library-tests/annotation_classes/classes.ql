import java

from ClassOrInterface x
where x.fromSource()
select x, x.getPrimaryQlClasses()

query predicate annotation(AnnotationType at, AnnotationElement ae) {
  at.getAnAnnotationElement() = ae
}
