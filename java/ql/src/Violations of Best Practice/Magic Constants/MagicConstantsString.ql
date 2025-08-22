/**
 * @name Magic strings
 * @description A magic string makes code less readable and maintainable.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/magic-string
 * @tags maintainability
 *       readability
 *       statistical
 *       non-attributable
 */

import java
import MagicConstants

/**
 * Holds if the string is a standard system property as defined in:
 *
 * https://docs.oracle.com/javase/7/docs/api/java/lang/System.html#getProperties()
 */
predicate isSystemProperty(string e) {
  e =
    [
      "java.version", "java.vendor", "java.specification.version", "java.specification.vendor",
      "java.specification.name", "java.class.version", "java.class.path", "java.library.path",
      "java.io.tmpdir", "java.compiler", "java.ext.dirs", "os.name", "java.vendor.url", "os.arch",
      "os.version", "file.separator", "path.separator", "line.separator", "user.name", "user.home",
      "user.dir", "java.home", "java.vm.specification.version", "java.vm.specification.vendor",
      "java.vm.specification.name", "java.vm.version", "java.vm.vendor", "java.vm.name"
    ]
}

predicate trivialContext(Literal e) {
  // String concatenation.
  e.getParent() instanceof AddExpr
  or
  e.getParent() instanceof AssignAddExpr
  or
  exists(MethodCall ma |
    ma.getMethod().getName() = "append" and
    (e = ma.getAnArgument() or e = ma.getQualifier())
  )
  or
  // Standard property in a call to `System.getProperty()`.
  exists(MethodCall ma |
    ma.getMethod().getName() = "getProperty" and
    e = ma.getAnArgument() and
    ma.getMethod().getDeclaringType() instanceof TypeSystem and
    isSystemProperty(e.getValue())
  )
  or
  // Message in an exception.
  exists(ClassInstanceExpr constr |
    constr.getType().(RefType).getAStrictAncestor().hasName("Exception") and
    e = constr.getArgument(0)
  )
}

from StringLiteral e, string msg
where
  magicConstant(e, msg) and
  not trivialContext(e)
select e, msg
