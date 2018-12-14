/**
 * @name Character passed to StringBuffer or StringBuilder constructor
 * @description A character value is passed to the constructor of 'StringBuffer' or 'StringBuilder'. This value will
 *              be converted to an integer and interpreted as the buffer's initial capacity, which is probably not intended.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @id java/string-buffer-char-init
 * @tags reliability
 *       maintainability
 */

import java

class NewStringBufferOrBuilder extends ClassInstanceExpr {
  NewStringBufferOrBuilder() {
    exists(Class c | c = this.getConstructedType() |
      c.hasQualifiedName("java.lang", "StringBuilder") or
      c.hasQualifiedName("java.lang", "StringBuffer")
    )
  }

  string getName() { result = this.getConstructedType().getName() }
}

from NewStringBufferOrBuilder nsb
where nsb.getArgument(0).getType().hasName("char")
select nsb,
  "A character value passed to 'new " + nsb.getName() + "' is interpreted as the buffer capacity."
