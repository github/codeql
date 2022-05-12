import java

Type getAMentionedType(RefType type) {
  result = type
  or
  result = getAMentionedType(type).(Array).getElementType()
  or
  result = getAMentionedType(type).(ParameterizedType).getATypeArgument()
  or
  result = getAMentionedType(type).(NestedType).getEnclosingType()
}

Type getATypeUsedInClass(RefType type) {
  // Base cases:
  result = type.getAField().getType()
  or
  result = type.getAMethod().getReturnType()
  or
  result = type.getAMethod().getParameterType(_)
  or
  result = any(Expr e | e.getEnclosingCallable().getDeclaringType() = type).getType()
  or
  // Structural recursion over types:
  result = getAMentionedType(getATypeUsedInClass(type))
}

TypeVariable getATypeVariableInScope(RefType type) {
  result = type.getACallable().(GenericCallable).getATypeParameter()
  or
  result = type.(GenericType).getATypeParameter()
  or
  result = getAMentionedType(type.(ParameterizedType).getATypeArgument())
  or
  result = getATypeVariableInScope(type.getEnclosingType())
}

from ClassOrInterface typeUser, TypeVariable outOfScope
where
  outOfScope = getAMentionedType(typeUser) and not outOfScope = getATypeVariableInScope(typeUser)
select "Type " + typeUser + " uses out-of-scope type variable " + outOfScope
