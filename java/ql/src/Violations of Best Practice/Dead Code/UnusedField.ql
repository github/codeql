/**
 * @name Unused field
 * @description A field that is never used is probably unnecessary.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/unused-field
 * @tags maintainability
 *       useless-code
 *       external/cwe/cwe-561
 */

import java
import semmle.code.java.Reflection
import semmle.code.java.frameworks.Lombok

from Field f
where
  not (f.isPublic() or f.isProtected()) and
  f.fromSource() and
  not f.getDeclaringType() instanceof EnumType and
  not exists(VarAccess va | va.getVariable().(Field).getSourceDeclaration() = f) and
  // Exclude results in generated classes.
  not f.getDeclaringType() instanceof GeneratedClass and
  // Exclude fields that may be reflectively read (this includes standard serialization).
  not reflectivelyRead(f) and
  // Exclude fields with deliberately suppressed warnings.
  not f.suppressesWarningsAbout("unused") and
  // Exclude fields with relevant Lombok annotations.
  not f instanceof LombokGetterAnnotatedField
select f, "Unused field " + f.getName() + " in " + f.getDeclaringType().getName() + "."
