/**
 * @name Potential output resource leak
 * @description A resource that is opened for writing but not closed may cause a resource
 *              leak.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id java/output-resource-leak
 * @tags efficiency
 *       correctness
 *       resources
 *       external/cwe/cwe-404
 *       external/cwe/cwe-772
 */

import CloseType

predicate writerType(RefType t) {
  exists(RefType sup | sup = t.getAnAncestor() |
    sup.hasQualifiedName("java.io", ["Writer", "OutputStream"])
  )
}

predicate safeWriterType(RefType t) {
  exists(RefType sup | sup = t.getAnAncestor() |
    sup.hasQualifiedName("java.io", ["CharArrayWriter", "StringWriter", "ByteArrayOutputStream"])
  )
}

from ClassInstanceExpr cie, RefType t
where
  badCloseableInit(cie) and
  cie.getType() = t and
  writerType(t) and
  not safeWriterType(typeInDerivation(cie)) and
  not noNeedToClose(cie)
select cie, "This " + t.getName() + " is not always closed on method exit."
