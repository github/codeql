import java

class InterestingParameter extends Parameter {
  InterestingParameter() {
    this.getFile().getBaseName() = "primitiveArrays.kt"
  }
}

from InterestingParameter p, Array a, KotlinType ktType
where p.getType() = a and ktType = p.getKotlinType()
select p, a, a.getComponentType(), a.getElementType(), ktType

query predicate cloneMethods(Method m, string signature, Array declType, Type returnType, KotlinType ktReturnType) {
  any(InterestingParameter p).getType() = declType and
  signature = m.getSignature() and
  declType = m.getDeclaringType() and
  returnType = m.getReturnType() and
  ktReturnType = m.getReturnKotlinType()
}
