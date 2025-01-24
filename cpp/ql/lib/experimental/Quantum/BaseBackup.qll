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

// An operation = a specific loc in code
// An algorithm
// Properties
// Node -> Operation -> Algorithm -> Symmetric -> SpecificSymmetricAlgo
// -[Language-Specific]-> LibrarySymmetricAlgo -> Properties
// For example (nsted newtypes):
/*
 * newtype for each algo, and each one of those would have params for their properties
 * implementation: optional/range for example
 *
 *
 *
 * /**
 * Constructs an `Option` type that is a disjoint union of the given type and an
 * additional singleton element.
 */

module CryptographyBase<LocationSig Location, InputSig<Location> Input> {
  newtype TNode =
    TNodeUnknown() or
    TNodeAlgorithm() or
    TNodeOperation()

  /*
   * A cryptographic asset in code, i.e., an algorithm, operation, property, or known unknown.
   */

  abstract class Node extends TNode {
    // this would then extend LanguageNode
    abstract Location getLocation();

    abstract string toString();

    abstract Node getChild(int childIndex);

    final Node getAChild() { result = this.getChild(_) }

    final Node getAParent() { result.getAChild() = this }
  }

  final class KnownUnknown extends Node, TNodeUnknown {
    override string toString() { result = "unknown" }

    override Node getChild(int childIndex) { none() }

    override Location getLocation() { result instanceof Input::KnownUnknownLocation }
  }

  abstract class Operation extends Node, TNodeOperation {
    /**
     * Gets the algorithm associated with this operation.
     */
    abstract Node getAlgorithm();

    /**
     * Gets the name of this operation, e.g., "hash" or "encrypt".
     */
    abstract string getOperationName();

    final override Node getChild(int childIndex) { childIndex = 0 and result = this.getAlgorithm() }

    final override string toString() { result = this.getOperationName() }
  }

  abstract class Algorithm extends Node, TNodeAlgorithm {
    /**
     * Gets the name of this algorithm, e.g., "AES" or "SHA".
     */
    abstract string getAlgorithmName();
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

    abstract Node getDigestAlgorithm();
  }
}
