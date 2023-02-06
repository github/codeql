import java

class InstantiatedType extends ParameterizedType {
  InstantiatedType() { typeArgs(_, _, this) }
}

Type getAMentionedType(RefType type) {
  result = type
  or
  result = getAMentionedType(type).(Array).getElementType()
  or
  result = getAMentionedType(type).(InstantiatedType).getATypeArgument()
  or
  result = getAMentionedType(type).(NestedType).getEnclosingType()
  or
  result = getAMentionedType(type).(Wildcard).getATypeBound().getType()
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

Element getEnclosingElementStar(RefType e) {
  result = e
  or
  result.contains(e)
}

TypeVariable getATypeVariableInScope(RefType type) {
  exists(Element e | e = getEnclosingElementStar(type) |
    result = e.(RefType).getACallable().(GenericCallable).getATypeParameter()
    or
    result = e.(GenericType).getATypeParameter()
    or
    result = e.(GenericCallable).getATypeParameter()
    or
    result = getAMentionedType(e.(InstantiatedType).getATypeArgument())
  )
}

from ClassOrInterface typeUser, TypeVariable outOfScope
where
  outOfScope = getATypeUsedInClass(typeUser) and not outOfScope = getATypeVariableInScope(typeUser)
select "Type " + typeUser + " uses out-of-scope type variable " + outOfScope +
    ". Note the Java extractor is known to sometimes do this; the Kotlin extractor should not."
