class AnnotatedElement extends @cil_has_type_annotation {
  string toString() { none() }
}

class Field extends @cil_field {
  string toString() { none() }
}

from AnnotatedElement element, int annotation
where cil_type_annotation(element, annotation) and not element instanceof Field
select element, annotation
