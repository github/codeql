import javascript

string getFieldType(ParameterField field) {
  if exists(field.getTypeAnnotation())
  then result = field.getTypeAnnotation().toString()
  else result = "no type"
}

from ParameterField field
select field.getStartLine().getText(), field.getNameExpr().toString(), getFieldType(field)
