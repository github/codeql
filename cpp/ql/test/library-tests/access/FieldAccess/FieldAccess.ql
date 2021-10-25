import cpp

string describeAccess(FieldAccess access) {
  access instanceof PointerFieldAccess and result = "ptr"
  or
  access instanceof ReferenceFieldAccess and result = "ref"
  or
  access instanceof ValueFieldAccess and result = "val"
  or
  access instanceof ImplicitThisFieldAccess and result = "this"
}

from FieldAccess access
select access, concat(describeAccess(access), ", ")
