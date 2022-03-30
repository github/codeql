/**
 * @name Public static read-only fields should be named in PascalCase
 * @description Constant fields should use the relevant Microsoft-recommended naming scheme.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id cs/bad-constant-name
 * @tags maintainability
 *       readability
 *       naming
 */

import csharp

class PublicConstantField extends Field {
  PublicConstantField() {
    this.isPublic() and
    this.isStatic() and
    this.isReadOnly()
  }
}

from PublicConstantField f
where
  // The first character of the field's name is not uppercase.
  not f.getName().charAt(0).isUppercase()
  or
  // The field's name is uppercase.
  f.getName().isUppercase() and
  // The field's name is at least 4 characters long.
  f.getName().length() >= 4
select f, "Public static read-only fields should be named in PascalCase."
