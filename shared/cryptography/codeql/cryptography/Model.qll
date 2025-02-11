/**
 * A language-independent library for reasoning about cryptography.
 */

import codeql.util.Location
import codeql.util.Option

signature module InputSig<LocationSig Location> {
  class LocatableElement {
    Location getLocation();
  }

  class UnknownLocation instanceof Location;
}

module CryptographyBase<LocationSig Location, InputSig<Location> Input> {
  final class LocatableElement = Input::LocatableElement;

  final class UnknownLocation = Input::UnknownLocation;

  final class UnknownPropertyValue extends string {
    UnknownPropertyValue() { this = "<unknown>" }
  }

  private string getPropertyAsGraphString(NodeBase node, string key) {
    result =
      strictconcat(any(string value, Location location, string parsed |
            node.properties(key, value, location) and
            parsed = "(" + value + "," + location.toString() + ")"
          |
            parsed
          ), ","
      )
  }

  predicate nodes_graph_impl(NodeBase node, string key, string value) {
    key = "semmle.label" and
    value = node.toString()
    or
    // CodeQL's DGML output does not include a location
    key = "Location" and
    value = node.getLocation().toString()
    or
    // Known unknown edges should be reported as properties rather than edges
    node = node.getChild(key) and
    value = "<unknown>"
    or
    // Report properties
    value = getPropertyAsGraphString(node, key)
  }

  predicate edges_graph_impl(NodeBase source, NodeBase target, string key, string value) {
    key = "semmle.label" and
    target = source.getChild(value) and
    // Known unknowns are reported as properties rather than edges
    not source = target
  }

  /**
   * The base class for all cryptographic assets, such as operations and algorithms.
   *
   * Each `NodeBase` is a node in a graph of cryptographic operations, where the edges are the relationships between the nodes.
   */
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
     * Gets the origin of this node, e.g., a string literal in source describing it.
     */
    LocatableElement getOrigin(string value) { none() }

    /**
     * Returns the child of this node with the given edge name.
     *
     * This predicate is used by derived classes to construct the graph of cryptographic operations.
     */
    NodeBase getChild(string edgeName) { none() }

    /**
     * Defines properties of this node by name and either a value or location or both.
     *
     * This predicate is used by derived classes to construct the graph of cryptographic operations.
     */
    predicate properties(string key, string value, Location location) {
      key = "origin" and
      location = this.getOrigin(value).getLocation() and
      not location = this.getLocation()
    }

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
      edgeName = "uses" and
      if exists(this.getAlgorithm()) then result = this.getAlgorithm() else result = this
    }
  }

  abstract class Algorithm extends Asset {
    /**
     * Gets the name of this algorithm, e.g., "AES" or "SHA".
     */
    abstract string getAlgorithmName();

    /**
     * Gets the raw name of this algorithm from source (no parsing or formatting)
     */
    abstract string getRawAlgorithmName();

    final override string toString() { result = this.getAlgorithmName() }
  }

  /**
   * A hashing operation that processes data to generate a hash value.
   *
   * This operation takes an input message of arbitrary content and length and produces a fixed-size
   * hash value as the output using a specified hashing algorithm.
   */
  abstract class HashOperation extends Operation {
    abstract override HashAlgorithm getAlgorithm();

    override string getOperationName() { result = "HASH" }
  }

  newtype THashType =
    MD5() or
    SHA1() or
    SHA256() or
    SHA512() or
    OtherHashType()

  /**
   * A hashing algorithm that transforms variable-length input into a fixed-size hash value.
   */
  abstract class HashAlgorithm extends Algorithm {
    final predicate hashTypeToNameMapping(THashType type, string name) {
      type instanceof MD5 and name = "MD5"
      or
      type instanceof SHA1 and name = "SHA-1"
      or
      type instanceof SHA256 and name = "SHA-256"
      or
      type instanceof SHA512 and name = "SHA-512"
      or
      type instanceof OtherHashType and name = this.getRawAlgorithmName()
    }

    abstract THashType getHashType();

    override string getAlgorithmName() { this.hashTypeToNameMapping(this.getHashType(), result) }
  }

  /**
   * An operation that derives one or more keys from an input value.
   */
  abstract class KeyDerivationOperation extends Operation {
    override string getOperationName() { result = "KEY_DERIVATION" }
  }

  /**
   * An algorithm that derives one or more keys from an input value.
   */
  abstract class KeyDerivationAlgorithm extends Algorithm {
    abstract override string getAlgorithmName();
  }

  /**
   * HKDF key derivation function
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

  /**
   * PKCS #12 key derivation function
   */
  abstract class PKCS12KDF extends KeyDerivationAlgorithm {
    final override string getAlgorithmName() { result = "PKCS12KDF" }

    abstract HashAlgorithm getHashAlgorithm();

    override NodeBase getChild(string edgeName) {
      result = super.getChild(edgeName)
      or
      edgeName = "digest" and result = this.getHashAlgorithm()
    }
  }

  /*
   * TODO:
   *
   * Rule: No newtype representing a type of algorithm should be modelled with multiple interfaces
   *
   * Example 1: HKDF and PKCS12KDF are both key derivation algorithms.
   *            However, PKCS12KDF also has a property: the iteration count.
   *
   *            If we have HKDF and PKCS12KDF under TKeyDerivationType,
   *            someone modelling a library might try to make a generic identification of both of those algorithms.
   *
   *            They will therefore not use the specialized type for PKCS12KDF,
   *            meaning "from PKCS12KDF algo select algo" will have no results.
   *
   * Example 2: Each type below represents a common family of elliptic curves, with a shared interface, i.e.,
   *            predicates for library modellers to implement as well as the properties and edges reported.
   */

  /**
   * Elliptic curve algorithms
   */
  newtype TEllipticCurveFamily =
    NIST() or
    SEC() or
    NUMS() or
    PRIME() or
    BRAINPOOL() or
    CURVE25519() or
    CURVE448() or
    C2() or
    SM2() or
    ES() or
    OtherEllipticCurveFamilyType()

  abstract class EllipticCurve extends Algorithm {
    abstract string getKeySize(Location location);

    abstract TEllipticCurveFamily getCurveFamilyType();

    override predicate properties(string key, string value, Location location) {
      super.properties(key, value, location)
      or
      key = "key_size" and
      if exists(this.getKeySize(location))
      then value = this.getKeySize(location)
      else (
        value instanceof UnknownPropertyValue and location instanceof UnknownLocation
      )
      // other properties, like field type are possible, but not modeled until considered necessary
    }

    override string getAlgorithmName() { result = this.getRawAlgorithmName().toUpperCase() }

    /**
     * Mandating that for Elliptic Curves specifically, users are responsible
     * for providing as the 'raw' name, the official name of the algorithm.
     *
     * Casing doesn't matter, we will enforce further naming restrictions on
     * `getAlgorithmName` by default.
     *
     * Rationale: elliptic curve names can have a lot of variation in their components
     * (e.g., "secp256r1" vs "P-256"), trying to produce generalized set of properties
     * is possible to capture all cases, but such modeling is likely not necessary.
     * if all properties need to be captured, we can reassess how names are generated.
     */
    abstract override string getRawAlgorithmName();
  }

  /**
   * An encryption operation that processes plaintext to generate a ciphertext.
   * This operation takes an input message (plaintext) of arbitrary content and length and produces a ciphertext as the output using a specified encryption algorithm (with a mode and padding).
   */
  abstract class EncryptionOperation extends Operation {
    abstract override Algorithm getAlgorithm();

    override string getOperationName() { result = "ENCRYPTION" }
  }

  /**
   * Block cipher modes of operation algorithms
   */
  newtype TModeOperation =
    ECB() or
    CBC() or
    OtherMode()

  abstract class ModeOfOperation extends Algorithm {
    final private predicate modeToNameMapping(TModeOperation type, string name) {
      type instanceof ECB and name = "ECB"
      or
      type instanceof CBC and name = "CBC"
      or
      type instanceof OtherMode and name = this.getRawAlgorithmName()
    }

    abstract TModeOperation getModeType();

    override string getAlgorithmName() { this.modeToNameMapping(this.getModeType(), result) }
  }

  /**
   * A helper type for distinguishing between block and stream ciphers.
   */
  newtype TCipherStructure =
    Block() or
    Stream()

  /**
   * Symmetric algorithms
   */
  newtype TSymmetricCipherFamilyType =
    AES() or
    OtherSymmetricCipherFamilyType()

  abstract class SymmetricAlgorithm extends Algorithm {
    abstract TSymmetricCipherFamilyType getSymmetricCipherFamilyType();

    abstract string getKeySize(Location location);

    abstract TCipherStructure getCipherType();

    //mode, padding scheme, keysize, block/stream, auth'd
    //nodes = mode, padding scheme
    //properties = keysize, block/stream, auth'd
    //leave authd to lang specific
    override predicate properties(string key, string value, Location location) {
      super.properties(key, value, location)
      or
      key = "key_size" and
      if exists(this.getKeySize(location))
      then value = this.getKeySize(location)
      else (
        value instanceof UnknownPropertyValue and location instanceof UnknownLocation
      )
      //add more keys to index props
    }

    abstract ModeOfOperation getModeOfOperation();
  }
}
