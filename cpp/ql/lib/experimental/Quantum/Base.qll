/**
 * A language-independent library for reasoning about cryptography.
 */

import codeql.util.Location
import codeql.util.Option

signature module InputSig<LocationSig Location> {
  class KnownUnknownLocation extends Location;

  class LocatableElement {
    Location getLocation();
  }
}

module CryptographyBase<LocationSig Location, InputSig<Location> Input> {
  final class LocatableElement = Input::LocatableElement;

  newtype TNode =
    TNodeUnknown() or
    TNodeAsset() or
    TNodeValue() // currently unused

  class KnownNode = TNodeAsset or TNodeValue;

  abstract class NodeBase extends TNode {
    /**
     * Returns a string representation of this node, usually the name of the operation/algorithm/property.
     */
    abstract string toString();

    /**
     * Returns the location of this node in the code.
     */
    abstract Location getLocation();

    /**
     * Returns the child of this node with the given edge name.
     *
     * This predicate is used by derived classes to construct the graph of cryptographic operations.
     */
    NodeBase getChild(string edgeName) { none() }

    /**
     * Returns the parent of this node.
     */
    final NodeBase getAParent() { result.getChild(_) = this }
  }

  /**
   * A node representing an unknown value.
   *
   * If a property should have a value but that value is unknown, `UnknownNode` to represent that value.
   */
  final class UnknownNode extends NodeBase, TNodeUnknown {
    override string toString() { result = "unknown" }

    override Location getLocation() { result instanceof Input::KnownUnknownLocation }
  }

  /**
   * A node with a known location in the code.
   */
  abstract class LocatableNode extends NodeBase, TNodeAsset {
    abstract LocatableElement toElement();

    override Location getLocation() { result = this.toElement().getLocation() }
  }

  /**
   * A node representing a known asset, i.e., an algorithm, operation, or property.
   */
  class Asset = LocatableNode;

  /**
   * A cryptographic operation, such as hashing or encryption.
   */
  abstract class Operation extends Asset {
    /**
     * Gets the algorithm associated with this operation.
     */
    private NodeBase getAlgorithmOrUnknown() {
      if exists(this.getAlgorithm())
      then result = this.getAlgorithm()
      else result instanceof UnknownNode
    }

    abstract Algorithm getAlgorithm();

    /**
     * Gets the name of this operation, e.g., "hash" or "encrypt".
     */
    abstract string getOperationName();

    final override string toString() { result = this.getOperationName() }

    override NodeBase getChild(string edgeName) {
      edgeName = "algorithm" and
      this.getAlgorithmOrUnknown() = result
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
  abstract class HKDFAlgorithm extends KeyDerivationAlgorithm {
    final override string getAlgorithmName() { result = "HKDF" }

    private NodeBase getHashAlgorithmOrUnknown() {
      if exists(this.getHashAlgorithm())
      then result = this.getHashAlgorithm()
      else result instanceof UnknownNode
    }

    abstract HashAlgorithm getHashAlgorithm();

    /**
     * digest:HashAlgorithm
     */
    override NodeBase getChild(string edgeName) {
      result = super.getChild(edgeName)
      or
      edgeName = "digest" and result = this.getHashAlgorithmOrUnknown()
    }
  }
}
