/**
 * A language-independent library for reasoning about cryptography.
 */

import codeql.util.Location
import codeql.util.Option

signature module InputSig<LocationSig Location> {
  class LocatableElement {
    Location getLocation();
  }
}

module CryptographyBase<LocationSig Location, InputSig<Location> Input> {
  final class LocatableElement = Input::LocatableElement;

  abstract class NodeBase instanceof LocatableElement {
    /**
     * Returns a string representation of this node, usually the name of the operation/algorithm/property.
     */
    abstract string toString();

    /**
     * Returns the location of this node in the code.
     */
    Location getLocation() { result = super.getLocation() }

    /**
     * Returns the child of this node with the given edge name.
     *
     * This predicate is used by derived classes to construct the graph of cryptographic operations.
     */
    NodeBase getChild(string edgeName) { edgeName = "origin" and result = this.getOrigin() }

    /**
     * Gets the origin of this node, e.g., a string literal in source describing it.
     */
    NodeBase getOrigin() { none() }

    /**
     * Returns the parent of this node.
     */
    final NodeBase getAParent() { result.getChild(_) = this }
  }

  class Asset = NodeBase;

  /**
   * A cryptographic operation, such as hashing or encryption.
   */
  abstract class Operation extends Asset {
    /**
     * Gets the algorithm associated with this operation.
     */
    abstract Algorithm getAlgorithm();

    /**
     * Gets the name of this operation, e.g., "hash" or "encrypt".
     */
    abstract string getOperationName();

    final override string toString() { result = this.getOperationName() }

    override NodeBase getChild(string edgeName) {
      result = super.getChild(edgeName)
      or
      edgeName = "algorithm" and
      if exists(this.getAlgorithm()) then result = this.getAlgorithm() else result = this
    }
  }

  abstract class Algorithm extends Asset {
    /**
     * Gets the name of this algorithm, e.g., "AES" or "SHA".
     */
    abstract string getAlgorithmName();

    final override string toString() { result = this.getAlgorithmName() }
  }

  /**
   * A hashing operation that processes data to generate a hash value.
   * This operation takes an input message of arbitrary content and length and produces a fixed-size
   * hash value as the output using a specified hashing algorithm.
   */
  abstract class HashOperation extends Operation {
    abstract override HashAlgorithm getAlgorithm();

    override string getOperationName() { result = "hash" }
  }

  /**
   * A hashing algorithm that transforms variable-length input into a fixed-size hash value.
   */
  abstract class HashAlgorithm extends Algorithm { }

  abstract class SHA1 extends HashAlgorithm {
    override string getAlgorithmName() { result = "SHA1" }
  }

  /**
   * An operation that derives one or more keys from an input value.
   */
  abstract class KeyDerivationOperation extends Operation {
    override string getOperationName() { result = "key derivation" }
  }

  /**
   * An algorithm that derives one or more keys from an input value.
   */
  abstract class KeyDerivationAlgorithm extends Algorithm {
    abstract override string getAlgorithmName();
  }

  /**
   * HKDF Extract+Expand key derivation function.
   */
  abstract class HKDF extends KeyDerivationAlgorithm {
    final override string getAlgorithmName() { result = "HKDF" }

    abstract HashAlgorithm getHashAlgorithm();

    override NodeBase getChild(string edgeName) {
      result = super.getChild(edgeName)
      or
      edgeName = "digest" and result = this.getHashAlgorithm()
    }
  }

  abstract class PKCS12KDF extends KeyDerivationAlgorithm {
    final override string getAlgorithmName() { result = "PKCS12KDF" }

    abstract HashAlgorithm getHashAlgorithm();

    override NodeBase getChild(string edgeName) {
      result = super.getChild(edgeName)
      or
      edgeName = "digest" and result = this.getHashAlgorithm()
    }
  }
}
