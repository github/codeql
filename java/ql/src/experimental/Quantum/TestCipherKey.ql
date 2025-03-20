/**
 * @name "PQC Test"
 */

import experimental.Quantum.Language

from Crypto::CipherOperationNode op, Crypto::CipherAlgorithmNode a, Crypto::KeyArtifactNode k
where
  a = op.getAKnownCipherAlgorithm() and
  k = op.getAKey()
select op, op.getCipherOperationSubtype(), a, a.getRawAlgorithmName(), k, k.getSourceNode()
/*
 * from Crypto::CipherOperationNode op
 * where op.getLocation().getFile().getBaseName() = "AsymmetricEncryptionMacHybridCryptosystem.java"
 * select op, op.getAKey().getSourceNode()
 */

