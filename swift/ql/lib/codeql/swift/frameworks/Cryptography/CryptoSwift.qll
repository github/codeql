/** Provides models and concepts from the CryptoSwift library */

private import swift
private import codeql.swift.dataflow.DataFlow
private import codeql.swift.security.Cryptography

private class CryptoSwiftCallNode extends CryptographicOperation::Range {
  CryptoSwiftCallNode() { none() }

  override CryptographicAlgorithm getAlgorithm() { none() }

  override DataFlow::Node getAnInput() { none() }

  override BlockMode getBlockMode() { none() }
}
