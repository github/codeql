/**
 * @name Encryption using ECB
 * @description Using the ECB encryption mode can reveal patterns in encrypted data.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id unified/swift/ecb-encryption
 * @tags security
 *       external/cwe/cwe-327
 */

import unified

/**
 * A data flow configuration from a creation of an ECB mode instance to expressions that use
 * it to initialize a cipher.
 */
module EcbEncryptionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { Models::isSource(node, "ecb-block-mode") }

  predicate isSink(DataFlow::Node node) { Models::isSink(node, "encryption-block-mode") }
  // TODO: Model CommonCrypto ECB options and modes, also unsupported by original Swift.
}

module EcbEncryptionFlow = DataFlow::Global<EcbEncryptionConfig>;

import EcbEncryptionFlow::PathGraph

from EcbEncryptionFlow::PathNode sourceNode, EcbEncryptionFlow::PathNode sinkNode
where EcbEncryptionFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "The initialization of the cipher '" + sinkNode.getNode().toString() +
    "' uses the insecure ECB block mode from $@.", sourceNode.getNode(),
  sourceNode.getNode().toString()
