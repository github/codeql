/**
 * @id java/examples/field-read
 * @name Read of field
 * @description Finds reads of aField (defined on com.example.Class)
 * @tags field
 *       read
 */

import java

from Field f, FieldRead read
where
  f.hasName("aField") and
  f.getDeclaringType().hasQualifiedName("com.example", "Class") and
  f = read.getField()
select read
