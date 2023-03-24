import java

from Method m, string origin, Annotation a
where
  m.fromSource() and
  (
    origin = "return value" and a = m.getAnAnnotation()
    or
    origin = "parameter" and a = m.getAParameter().getAnAnnotation()
  )
select m, origin, a
