/**
 * Provides classes and predicates for common functionality.
 */

import csharp

/**
 * Constructs a string containing the text `text` with a
 * link to the element `e`.
 */
bindingset[text]
string link(Element e, string text) {
  exists(string path, int sl, int sc, int el, int ec, string url, Location location |
    location = e.getLocation() and
    location.hasLocationInfo(_, sl, sc, el, ec) and
    path = location.getFile().getRelativePath() and
    url = "relative://" + path + ":" + sl + ":" + sc + ":" + el + ":" + ec and
    result = "[[\"" + text + "\"|\"" + url + "\"]]"
  )
}

/**
 * Holds if the object creation 'oc' is the creation of the reference type with the specified 'qualifiedName', or a class derived from
 * the class with the specified 'qualifiedName'.
 */
predicate isCreatingObject(ObjectCreation oc, string qualifiedName) {
  exists(RefType t | t = oc.getType() | t.getBaseClass*().hasQualifiedName(qualifiedName))
}

/**
 * Holds if the method call 'mc' is returning the reference type with the specified 'qualifiedName.
 * and the target of the method call is a library method.
 */
predicate isReturningObject(MethodCall mc, string qualifiedName) {
  mc.getTarget().fromLibrary() and
  exists(RefType t | t = mc.getType() | t.hasQualifiedName(qualifiedName))
}

/**
 * Holds if the method call 'mc' is a call on the library method target with the specified 'qualifiedName' and 'methodName', and an argument at
 * index 'argumentIndex' has the specified value 'argumentValue' (case-insensitive)
 */
bindingset[argumentValue]
predicate isMethodCalledWithArg(
  MethodCall mc, string qualifiedName, string methodName, int argumentIndex, string argumentValue
) {
  mc.getTarget().fromLibrary() and
  mc.getTarget().hasQualifiedName(qualifiedName, methodName) and
  mc.getArgument(argumentIndex).getValue().toUpperCase() = argumentValue.toUpperCase()
}

/**
 * Holds if the method call 'mc' is a call on the library method target with the specified 'qualifiedName' and 'methodName' and no arguments
 */
predicate isMethodCalledWithoutArgs(MethodCall mc, string qualifiedName, string methodName) {
  mc.getTarget().fromLibrary() and
  mc.getTarget().hasQualifiedName(qualifiedName, methodName) and
  mc.getNumberOfArguments() = 0
}

/**
 * Holds if method access 'ma' is an access to member 'name' of a class specified with 'qualifiedName'
 */
predicate isAccessorForName(MemberAccess ma, string qualifiedName, string name) {
  ma.getTarget().fromLibrary() and
  ma.getTarget().getDeclaringType().hasQualifiedName(qualifiedName) and
  ma.getTarget().hasName(name)
}

/**
 * Gets value set on the property 'prop' either with initializer of with a property setter on the object created with ObjectCreation 'create'
 */
Expr getAValueForProp(ObjectCreation create, string prop) {
  // values set in object init
  exists(MemberInitializer init |
    init = create.getInitializer().(ObjectInitializer).getAMemberInitializer() and
    init.getLValue().(PropertyAccess).getTarget().hasName(prop) and
    result = init.getRValue()
  )
  or
  // values set on var that create is assigned to
  exists(Assignment propAssign |
    DataFlow::localFlow(DataFlow::exprNode(create),
      DataFlow::exprNode(propAssign.getLValue().(PropertyAccess).getQualifier())) and
    propAssign.getLValue().(PropertyAccess).getTarget().hasName(prop) and
    result = propAssign.getRValue()
  )
}
