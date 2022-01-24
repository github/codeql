import cil
import semmle.code.cil.Type

private string elementType(Element e) {
  e instanceof Method and result = "method"
  or
  e instanceof Property and result = "property"
  or
  e instanceof Parameter and result = "parameter"
  or
  e instanceof LocalVariable and result = "local"
  or
  e instanceof FunctionPointerType and result = "fnptr"
  or
  not e instanceof Method and
  not e instanceof Property and
  not e instanceof Parameter and
  not e instanceof LocalVariable and
  not e instanceof FunctionPointerType and
  result = "other"
}

from Element e, int i
where
  cil_type_annotation(e, i) and
  (
    not e instanceof Parameter or
    e.(Parameter).getDeclaringElement().(Method).getDeclaringType().getQualifiedName() !=
      "System.Environment" // There are OS specific methods in this class
  )
select e.toString(), elementType(e), i
