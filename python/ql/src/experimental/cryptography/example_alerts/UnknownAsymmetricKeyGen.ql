/**
 * @name Unknown key generation key size
 * @description
 * @id py/unknown-asymmetric-key-gen-size
 * @kind problem
 * @problem.severity error
 * @precision high
 * @tags external/cwe/cwe-326
 */

import python
import experimental.cryptography.Concepts

from AsymmetricKeyGen op, DataFlow::Node configSrc, string algName
where
  not op.hasKeySize(configSrc) and
  configSrc = op.getKeyConfigSrc() and
  algName = op.getAlgorithm().getName()
select op,
  "Non-statically verifiable key size used for key generation for algorithm " + algName.toString() +
    " at config source $@", configSrc, configSrc.toString()
