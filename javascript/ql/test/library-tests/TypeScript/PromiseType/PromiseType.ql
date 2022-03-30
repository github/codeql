import javascript

string getElementType(PromiseType t) {
  result = t.getElementType().toString()
  or
  not exists(t.getElementType().toString()) and
  result = "<missing>"
}

from VarDecl decl, PromiseType type
where type = decl.getTypeAnnotation().getType()
select decl.getName(), type, getElementType(type)
