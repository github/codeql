/**
 * @id cs/examples/field-read
 * @name Read of field
 * @description Finds reads of 'VirtualAddress' (defined on 'Mono.Cecil.PE.Section').
 * @tags field
 *       read
 */

import csharp

from Field f, FieldRead read
where
  f.hasName("VirtualAddress") and
  f.getDeclaringType().hasFullyQualifiedName("Mono.Cecil.PE", "Section") and
  f = read.getTarget()
select read
