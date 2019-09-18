import default

from Annotation ann, Element elt
where
  elt = ann.getAnnotatedElement() and
  elt.fromSource()
select ann, elt
