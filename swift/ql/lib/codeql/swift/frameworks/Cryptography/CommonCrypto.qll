/** Provides models and concepts from the CommonCrypto library */

private import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.security.Cryptography

private class CommonCryptoCallNode extends CryptographicOperation::Range {
  CommonCryptoCallNode() { none() }

  override CryptographicAlgorithm getAlgorithm() { none() }

  override DataFlow::Node getAnInput() { none() }

  override BlockMode getBlockMode() { none() }
}
