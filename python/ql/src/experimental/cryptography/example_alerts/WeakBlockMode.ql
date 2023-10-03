/**
 * @name Weak block mode
 * @description Finds uses of symmetric encryption block modes that are weak, obsolete, or otherwise unaccepted.
 * @id py/weak-block-mode
 * @kind problem
 * @problem.severity error
 * @precision high
 * @tags external/cwe/cwe-327
 */

import python
import experimental.cryptography.Concepts

from CryptographicArtifact op, string msg
where
  // False positive hack, some projects are directly including all of cryptography,
  // filter any match that is in cryptography/hazmat
  // Specifically happening for ECB being used in keywrap operations internally to the cryptography keywrap/unwrap API
  not op.asExpr()
      .getLocation()
      .getFile()
      .getAbsolutePath()
      .toString()
      .matches("%cryptography/hazmat/%") and
  (
    op instanceof BlockMode and
    // ECB is only allowed for KeyWrapOperations, i.e., only alert on ECB is not a KeyWrapOperation
    (op.(BlockMode).getBlockModeName() = "ECB" implies not op instanceof KeyWrapOperation) and
    exists(string name | name = op.(BlockMode).getBlockModeName() |
      // Only CBC, CTS, XTS modes are allowed.
      //  https://liquid.microsoft.com/Web/Object/Read/MS.Security/Requirements/Microsoft.Security.Cryptography.10002
      not name = ["CBC", "CTS", "XTS"] and
      if name = unknownAlgorithm()
      then msg = "Use of unrecognized block mode algorithm."
      else
        if name in ["GCM", "CCM"]
        then
          msg =
            "Use of block mode algorithm " + name +
              " requires special crypto board approval/review."
        else msg = "Use of unapproved block mode algorithm or API " + name + "."
    )
    or
    op instanceof SymmetricCipher and
    not op.(SymmetricCipher).hasBlockMode() and
    msg = "Cipher has unspecified block mode algorithm."
  )
select op, msg
