/**
 * @name Hard-coded symmetric encryption key
 * @description The .Key property or rgbKey parameter of a SymmetricAlgorithm should never be a hardcoded value.
 * @kind path-problem
 * @id cs/hard-coded-symmetric-encryption-key
 * @problem.severity error
 * @tags security
 */

/*
 * consider: @precision high
 */

import csharp
import semmle.code.csharp.security.cryptography.HardcodedSymmetricEncryptionKey::HardcodedSymmetricEncryptionKey
import DataFlow::PathGraph

from TaintTrackingConfiguration c, DataFlow::PathNode source, DataFlow::PathNode sink
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "Hard-coded symmetric $@ is used in symmetric algorithm in " +
    sink.getNode().(Sink).getDescription() + ".", source.getNode(), "key"
