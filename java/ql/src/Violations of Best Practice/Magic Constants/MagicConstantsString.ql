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
 * http://docs.oracle.com/javase/7/docs/api/java/lang/System.html#getProperties()
 */
predicate isSystemProperty(string e) {
  e = "java.version" or
  e = "java.vendor" or
  e = "java.vendor.url" or
  e = "java.home" or
  e = "java.vm.specification.version" or
  e = "java.vm.specification.vendor" or
  e = "java.vm.specification.name" or
  e = "java.vm.version" or
  e = "java.vm.vendor" or
  e = "java.vm.name" or
  e = "java.specification.version" or
  e = "java.specification.vendor" or
  e = "java.specification.name" or
  e = "java.class.version" or
  e = "java.class.path" or
  e = "java.library.path" or
  e = "java.io.tmpdir" or
  e = "java.compiler" or
  e = "java.ext.dirs" or
  e = "os.name" or
  e = "os.arch" or
  e = "os.version" or
  e = "file.separator" or
  e = "path.separator" or
  e = "line.separator" or
  e = "user.name" or
  e = "user.home" or
  e = "user.dir"
}

predicate trivialContext(Literal e) {
  // String concatenation.
  e.getParent() instanceof AddExpr
  or
  e.getParent() instanceof AssignAddExpr
  or
  exists(MethodAccess ma |
    ma.getMethod().getName() = "append" and
    (e = ma.getAnArgument() or e = ma.getQualifier())
  )
  or
  // Standard property in a call to `System.getProperty()`.
  exists(MethodAccess ma |
    ma.getMethod().getName() = "getProperty" and
    e = ma.getAnArgument() and
    ma.getMethod().getDeclaringType() instanceof TypeSystem and
    isSystemProperty(e.getValue())
  )
  or
  // Message in an exception.
  exists(ClassInstanceExpr constr |
    constr.getType().(RefType).getASupertype+().hasName("Exception") and
    e = constr.getArgument(0)
  )
}

from StringLiteral e, string msg
where
  magicConstant(e, msg) and
  not trivialContext(e)
select e, msg
