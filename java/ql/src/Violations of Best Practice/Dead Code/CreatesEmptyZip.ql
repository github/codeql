/**
 * @name Creates empty ZIP file entry
 * @description Omitting a call to 'ZipOutputStream.write' when writing a ZIP file to an output
 *              stream means that an empty ZIP file entry is written.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/empty-zip-file-entry
 * @tags reliability
 *       readability
 */

import java
import semmle.code.java.dataflow.SSA

/** A class that is a descendant of `java.util.zip.ZipOutputStream`. */
class ZipOutputStream extends Class {
  ZipOutputStream() {
    exists(Class zip | zip.hasQualifiedName("java.util.zip", "ZipOutputStream") |
      this.hasSupertype*(zip)
    )
  }

  Method putNextEntry() {
    (
      result.getDeclaringType() = this or
      this.inherits(result)
    ) and
    result.getName() = "putNextEntry" and
    result.getNumberOfParameters() = 1 and
    result.getAParamType().(Class).hasQualifiedName("java.util.zip", "ZipEntry")
  }

  Method closeEntry() {
    (
      result.getDeclaringType() = this or
      this.inherits(result)
    ) and
    result.getName() = "closeEntry" and
    result.getNumberOfParameters() = 0
  }
}

from
  ZipOutputStream jos, MethodAccess putNextEntry, MethodAccess closeEntry, RValue putNextQualifier,
  RValue closeQualifier
where
  putNextEntry.getMethod() = jos.putNextEntry() and
  closeEntry.getMethod() = jos.closeEntry() and
  putNextQualifier = putNextEntry.getQualifier() and
  closeQualifier = closeEntry.getQualifier() and
  adjacentUseUseSameVar(putNextQualifier, closeQualifier) and
  not exists(RValue other |
    adjacentUseUseSameVar(other, closeQualifier) and
    other != putNextQualifier
  )
select closeEntry, "Empty ZIP file entry created."
