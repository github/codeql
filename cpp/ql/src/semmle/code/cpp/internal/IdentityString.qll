import semmle.code.cpp.Declaration
import semmle.code.cpp.Type

/**
 * Gets a string containing the scope in which this declaration is declared.
 */
string getScopePrefix(Declaration decl) {
  decl.isMember() and result = decl.getDeclaringType().getIdentityString() + "::" or
  (
    decl.isTopLevel() and 
    exists (string parentName |
      parentName = decl.getNamespace().getQualifiedName() and
      (
        parentName != "" and result = parentName + "::" or
        parentName = "" and result = ""
      )
    )
  ) or
  exists(UserType type |
    type = decl and type.isLocal() and result = "(" + type.getEnclosingFunction().getIdentityString() + ")::"
  )
}

/**
 * Gets the identity string of a type used as a parameter. Identical to `Type.getTypeIdentityString()`, except that
 * it returns `...` for `UnknownType`, which is used to represent variable arguments.
 */
string getParameterTypeString(Type parameterType) {
  if parameterType instanceof UnknownType then
    result = "..."
  else
    result = parameterType.getTypeIdentityString()
}
