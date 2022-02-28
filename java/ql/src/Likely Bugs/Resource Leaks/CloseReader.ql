/**
 * @name Potential input resource leak
 * @description A resource that is opened for reading but not closed may cause a resource
 *              leak.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id java/input-resource-leak
 * @tags efficiency
 *       correctness
 *       resources
 *       external/cwe/cwe-404
 *       external/cwe/cwe-772
 */

import CloseType

predicate readerType(RefType t) {
  exists(RefType sup | sup = t.getAnAncestor() |
    sup.hasQualifiedName("java.io", ["Reader", "InputStream"]) or
    sup.hasQualifiedName("java.util.zip", "ZipFile")
  )
}

predicate safeReaderType(RefType t) {
  exists(RefType sup | sup = t.getAnAncestor() |
    sup.hasQualifiedName("java.io", ["CharArrayReader", "StringReader", "ByteArrayInputStream"])
    or
    // Note: It is unclear which specific class this is supposed to match
    sup.hasName("StringInputStream")
  )
}

from ClassInstanceExpr cie, RefType t
where
  badCloseableInit(cie) and
  cie.getType() = t and
  readerType(t) and
  not safeReaderType(typeInDerivation(cie)) and
  not noNeedToClose(cie)
select cie, "This " + t.getName() + " is not always closed on method exit."
