/**
 * @name Weak asymmetric key size
 * @description Using RSA keys smaller than 2048 bits does not provide adequate security.
 * @kind problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id powershell/microsoft/security/weak-asymmetric-key
 * @tags security
 *       external/cwe/cwe-326
 */

import powershell
import semmle.code.powershell.ApiGraphs
import semmle.code.powershell.dataflow.DataFlow

/**
 * Holds if `keySize` is below the minimum RSA key size of 2048 bits.
 */
bindingset[keySize]
predicate isWeakKeySize(int keySize) { keySize > 0 and keySize < 2048 }

/**
 * An RSA.Create(keySize) or RSA::new(keySize) call via the API graph with a weak key size.
 */
class WeakRsaCreateCall extends DataFlow::CallNode {
  int keySize;

  WeakRsaCreateCall() {
    exists(string method |
      method = ["create", "new"] and
      this =
        API::getTopLevelMember("system")
            .getMember("security")
            .getMember("cryptography")
            .getMember(["rsa", "rsacryptoserviceprovider"])
            .getMember(method)
            .asCall()
    ) and
    keySize = this.getAnArgument().asExpr().getExpr().(ConstExpr).getValueString().toInt() and
    isWeakKeySize(keySize)
  }

  int getKeySize() { result = keySize }
}

/**
 * A New-Object RSACryptoServiceProvider(keySize) with a weak key size.
 */
class WeakRsaCspCreation extends DataFlow::ObjectCreationNode {
  int keySize;

  WeakRsaCspCreation() {
    exists(string objName |
      objName =
        this.getExprNode().getExpr().(CallExpr).getAnArgument().getValue().asString().toLowerCase() and
      objName =
        [
          "system.security.cryptography.rsacryptoserviceprovider",
          "rsacryptoserviceprovider"
        ]
    ) and
    exists(DataFlow::Node arg |
      arg = this.getAnArgument() and
      keySize = arg.asExpr().getExpr().(ConstExpr).getValueString().toInt() and
      isWeakKeySize(keySize)
    )
  }

  int getKeySize() { result = keySize }
}

from DataFlow::Node node, int keySize
where
  exists(WeakRsaCreateCall c | node = c and keySize = c.getKeySize())
  or
  exists(WeakRsaCspCreation c | node = c and keySize = c.getKeySize())
select node,
  "RSA key size " + keySize.toString() + " bits is below the minimum of 2048 bits."
