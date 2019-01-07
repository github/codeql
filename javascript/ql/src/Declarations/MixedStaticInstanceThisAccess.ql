/**
 * @name Wrong use of 'this' for static method
 * @description A reference to a static method from within an instance method needs to be qualified with the class name, not `this`.
 * @kind problem
 * @problem.severity error
 * @id js/mixed-static-instance-this-access
 * @tags correctness
 *       methods
 * @precision high
 */

import javascript

/** Holds if `base` declares or inherits method `m` with the given `name`. */
predicate hasMethod(ClassDefinition base, string name, MethodDefinition m) {
  m = base.getMethod(name) or
  hasMethod(base.getSuperClassDefinition(), name, m)
}

/**
 * Holds if `access` is in`fromMethod`, and it references `toMethod` through `this`,
 * where `fromMethod` and `toMethod` are of kind `fromKind` and `toKind`, respectively.
 */
predicate isLocalMethodAccess(
  PropAccess access, MethodDefinition fromMethod, string fromKind, MethodDefinition toMethod,
  string toKind
) {
  hasMethod(fromMethod.getDeclaringClass(), access.getPropertyName(), toMethod) and
  access.getEnclosingFunction() = fromMethod.getBody() and
  access.getBase() instanceof ThisExpr and
  fromKind = getKind(fromMethod) and
  toKind = getKind(toMethod)
}

string getKind(MethodDefinition m) {
  if m.isStatic() then result = "static" else result = "instance"
}

from
  PropAccess access, MethodDefinition fromMethod, MethodDefinition toMethod, string fromKind,
  string toKind
where
  isLocalMethodAccess(access, fromMethod, fromKind, toMethod, toKind) and
  toKind != fromKind and
  // exceptions
  not (
    // the class has a second member with the same name and the right kind
    isLocalMethodAccess(access, fromMethod, _, _, fromKind)
    or
    // there is a dynamically assigned second member with the same name and the right kind
    exists(AnalyzedPropertyWrite apw, AbstractClass declaringClass, AbstractValue base |
      "static" = fromKind and base = declaringClass
      or
      "instance" = fromKind and base = TAbstractInstance(declaringClass)
    |
      declaringClass = TAbstractClass(fromMethod.getDeclaringClass()) and
      apw.writes(base, access.getPropertyName(), _)
    )
    or
    // the access is an assignment, probably deliberate
    access instanceof LValue
  )
select access,
  "Access to " + toKind + " method $@ from " + fromKind +
    " method $@ is not possible through `this`.", toMethod, toMethod.getName(), fromMethod,
  fromMethod.getName()
