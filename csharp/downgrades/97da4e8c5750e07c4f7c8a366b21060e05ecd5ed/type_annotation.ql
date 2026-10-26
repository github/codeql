class AnnotatedElement extends @has_type_annotation {
  string toString() { none() }
}

class Field extends @field {
  string toString() { none() }
}

from AnnotatedElement element, int annotation
where type_annotation(element, annotation) and not element instanceof Field
select element, annotation
