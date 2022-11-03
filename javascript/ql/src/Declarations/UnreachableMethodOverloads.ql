/**
 * @name Unreachable method overloads
 * @description Having multiple overloads with the same parameter types in TypeScript
 *              makes all overloads except the first one unreachable, as the compiler
 *              always resolves calls to the textually first matching overload.
 * @kind problem
 * @problem.severity warning
 * @id js/unreachable-method-overloads
 * @precision high
 * @tags correctness
 *       typescript
 */

import javascript

/**
 * Gets the `i`th parameter from the method signature.
 */
SimpleParameter getParameter(MethodSignature sig, int i) { result = sig.getBody().getParameter(i) }

/**
 * Gets a string-representation of the type-annotation from the `i`th parameter in the method signature.
 */
string getParameterTypeAnnotation(MethodSignature sig, int i) {
  result = getParameter(sig, i).getTypeAnnotation().toString()
}

/**
 * Gets the other overloads for an overloaded method signature.
 */
MethodSignature getOtherMatchingSignatures(MethodSignature sig) {
  signaturesMatch(result, sig) and
  result != sig
}

/**
 * Gets the kind of the member-declaration. Either "static" or "instance".
 */
string getKind(MemberDeclaration m) {
  if m.isStatic() then result = "static" else result = "instance"
}

/**
 * A call-signature that originates from a MethodSignature in the AST.
 */
private class MethodCallSig extends CallSignatureType {
  string name;

  MethodCallSig() {
    exists(MethodSignature sig |
      this = sig.getBody().getCallSignature() and
      name = sig.getName()
    )
  }

  /**
   * Gets the name of any member that has this signature.
   */
  string getName() { result = name }
}

/**
 * Holds if the two call signatures could be overloads of each other and have the same parameter types.
 */
predicate matchingCallSignature(MethodCallSig method, MethodCallSig other) {
  method.getName() = other.getName() and
  method.getNumOptionalParameter() = other.getNumOptionalParameter() and
  method.getNumParameter() = other.getNumParameter() and
  method.getNumRequiredParameter() = other.getNumRequiredParameter() and
  // purposely not looking at number of type arguments.
  method.getKind() = other.getKind() and
  forall(int i | i in [0 .. -1 + method.getNumParameter()] |
    method.getParameter(i) = other.getParameter(i) // This is sometimes imprecise, so it is still a good idea to compare type annotations.
  ) and
  // shared type parameters are equal.
  forall(int i |
    i in [0 .. -1 +
          min(int num | num = method.getNumTypeParameter() or num = other.getNumTypeParameter())]
  |
    method.getTypeParameterBound(i) = other.getTypeParameterBound(i)
  )
}

/**
 * Gets which overload index the MethodSignature has among the overloads of the same name.
 */
int getOverloadIndex(MethodSignature sig) {
  sig.getDeclaringType().getMethodOverload(sig.getName(), result) = sig
}

/**
 * Holds if the two method signatures are overloads of each other and have the same parameter types.
 */
predicate signaturesMatch(MethodSignature method, MethodSignature other) {
  // declared in the same interface/class.
  method.getDeclaringType() = other.getDeclaringType() and
  // same static modifier.
  getKind(method) = getKind(other) and
  // same name.
  method.getName() = other.getName() and
  // same number of parameters.
  method.getBody().getNumParameter() = other.getBody().getNumParameter() and
  // same this parameter (if exists)
  (
    not exists(method.getBody().getThisTypeAnnotation()) and
    not exists(other.getBody().getThisTypeAnnotation())
    or
    method.getBody().getThisTypeAnnotation().getType() =
      other.getBody().getThisTypeAnnotation().getType()
  ) and
  // The types are compared in matchingCallSignature. This is a consistency check that the textual representation of the type-annotations are somewhat similar.
  forall(int i | i in [0 .. -1 + method.getBody().getNumParameter()] |
    getParameterTypeAnnotation(method, i) = getParameterTypeAnnotation(other, i)
  ) and
  matchingCallSignature(method.getBody().getCallSignature(), other.getBody().getCallSignature())
}

from ClassOrInterface decl, string name, MethodSignature previous, MethodSignature unreachable
where
  previous = decl.getMethod(name) and
  unreachable = getOtherMatchingSignatures(previous) and
  // If the method is part of inheritance between classes/interfaces, then there can sometimes be reasons for having this pattern.
  not exists(decl.getASuperTypeDeclaration().getMethod(name)) and
  not exists(ClassOrInterface sub |
    decl = sub.getASuperTypeDeclaration() and
    exists(sub.getMethod(name))
  ) and
  // If a later method overload has more type parameters, then that overload can be selected by explicitly declaring the type arguments at the callsite.
  // This comparison removes those cases.
  unreachable.getBody().getNumTypeParameter() <= previous.getBody().getNumTypeParameter() and
  // We always select the first of the overloaded methods.
  not exists(MethodSignature later | later = getOtherMatchingSignatures(previous) |
    getOverloadIndex(later) < getOverloadIndex(previous)
  )
select unreachable,
  "This overload of " + name + "() is unreachable, the $@ overload will always be selected.",
  previous, "previous"
