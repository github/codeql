/**
 * @name List field accesses
 * @description Lists all field read/write operations
 * @kind table
 * @id jvm/list-field-access
 */

import semmle.code.binary.ast.internal.JvmInstructions

from JvmFieldAccess access
select access.getEnclosingMethod().getFullyQualifiedName() as method,
  access.getMnemonic() as accessType, access.getFieldClassName() as fieldClass,
  access.getFieldName() as fieldName, access.getFieldDescriptor() as descriptor
