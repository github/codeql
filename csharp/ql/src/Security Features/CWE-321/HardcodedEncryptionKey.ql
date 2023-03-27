/**
 * @name Hard-coded encryption key
 * @description The .Key property or rgbKey parameter of a SymmetricAlgorithm should never be a hard-coded value.
 * @kind path-problem
 * @id cs/hardcoded-key
 * @problem.severity error
 * @security-severity 8.1
 * @tags security
 *       external/cwe/cwe-320
 */

/*
 * consider: @precision high
 */

import csharp
import semmle.code.csharp.security.cryptography.EncryptionKeyDataFlowQuery
import SymmetricKeyTaintTracking::PathGraph

/**
 * The creation of a literal byte array.
 */
class ByteArrayLiteralSource extends KeySource {
  ByteArrayLiteralSource() {
    this.asExpr() =
      any(ArrayCreation ac |
        ac.getArrayType().getElementType() instanceof ByteType and
        ac.hasInitializer()
      )
  }
}

/**
 * Any string literal as a source
 */
class StringLiteralSource extends KeySource {
  StringLiteralSource() { this.asExpr() instanceof StringLiteral }
}

from
  SymmetricKeyTaintTracking::PathNode source, SymmetricKeyTaintTracking::PathNode sink,
  KeySource srcNode, SymmetricEncryptionKeySink sinkNode
where
  SymmetricKeyTaintTracking::flowPath(source, sink) and
  source.getNode() = srcNode and
  sink.getNode() = sinkNode
select sink.getNode(), source, sink,
  "This hard-coded $@ is used in symmetric algorithm in " + sinkNode.getDescription(), srcNode,
  "symmetric key"
