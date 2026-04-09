/**
 * @name Use of weak HMAC algorithm
 * @description Using weak HMAC algorithms like HMACMD5 or HMACSHA1 can compromise message authentication.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id powershell/microsoft/security/weak-hmac
 * @tags security
 *       external/cwe/cwe-327
 *       external/cwe/cwe-328
 */

import powershell
import semmle.code.powershell.ApiGraphs
import semmle.code.powershell.dataflow.DataFlow
import semmle.code.powershell.security.cryptography.CryptographyModule

/**
 * Holds if `name` is a weak HMAC algorithm name (lowercase).
 */
predicate isWeakHmacAlgorithm(string name) {
  name = ["hmacmd5", "hmacsha1", "hmacripemd160"]
}

/** A weak HMAC algorithm instantiated via New-Object. */
class WeakHmacObjectCreation extends DataFlow::ObjectCreationNode {
  string algName;

  WeakHmacObjectCreation() {
    exists(string objName |
      objName =
        this.getExprNode().getExpr().(CallExpr).getAnArgument().getValue().asString().toLowerCase() and
      (
        objName = "system.security.cryptography." + algName or
        objName = algName
      ) and
      isWeakHmacAlgorithm(algName)
    )
  }

  string getName() { result = algName }
}

/** A weak HMAC algorithm instantiated via [Type]::Create() or [Type]::new(). */
class WeakHmacCreateCall extends DataFlow::CallNode {
  string algName;

  WeakHmacCreateCall() {
    isWeakHmacAlgorithm(algName) and
    (
      this =
        API::getTopLevelMember("system")
            .getMember("security")
            .getMember("cryptography")
            .getMember(algName)
            .getMember("create")
            .asCall()
      or
      this =
        API::getTopLevelMember("system")
            .getMember("security")
            .getMember("cryptography")
            .getMember(algName)
            .getMember("new")
            .asCall()
    )
  }

  string getName() { result = algName }
}

/** A weak HMAC algorithm passed as string to CryptoConfig.CreateFromName(). */
class WeakHmacCreateFromNameCall extends CryptoAlgorithmCreateFromNameCall {
  string algName;

  WeakHmacCreateFromNameCall() {
    objectName = ["", "system.security.cryptography."] + algName and
    isWeakHmacAlgorithm(algName)
  }

  string getHmacName() { result = algName }
}

from DataFlow::Node node, string algName
where
  exists(WeakHmacObjectCreation c | node = c and algName = c.getName())
  or
  exists(WeakHmacCreateCall c | node = c and algName = c.getName())
  or
  exists(WeakHmacCreateFromNameCall c | node = c and algName = c.getHmacName())
select node, "Use of weak HMAC algorithm: " + algName + ". Use HMACSHA256 or stronger."
