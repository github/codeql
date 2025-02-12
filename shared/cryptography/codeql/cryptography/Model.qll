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

  newtype TNode =
    THashOperation(LocatableElement e) or
    THashAlgorithm(LocatableElement e) or
    TKeyDerivationOperation(LocatableElement e) or
    TKeyDerivationAlgorithm(LocatableElement e) or
    TEncryptionOperation(LocatableElement e) or
    TSymmetricAlgorithm(LocatableElement e) or
    TEllipticCurveAlgorithm(LocatableElement e) or
    TModeOfOperationAlgorithm(LocatableElement e)

  /**
   * The base class for all cryptographic assets, such as operations and algorithms.
   *
   * Each `NodeBase` is a node in a graph of cryptographic operations, where the edges are the relationships between the nodes.
   */
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
    final override string toString() { result = this.getAlgorithmType() }

    /**
     * Gets the name of this algorithm, e.g., "AES" or "SHA".
     */
    abstract string getAlgorithmName();

    /**
     * Gets the raw name of this algorithm from source (no parsing or formatting)
     */
    abstract string getRawAlgorithmName();

    /**
     * Gets the type of this algorithm, e.g., "hash" or "key derivation".
     */
    abstract string getAlgorithmType();

    override predicate properties(string key, string value, Location location) {
      super.properties(key, value, location)
      or
      // [ONLY_KNOWN]
      key = "name" and value = this.getAlgorithmName() and location = this.getLocation()
      or
      // [ONLY_KNOWN]
      key = "raw_name" and value = this.getRawAlgorithmName() and location = this.getLocation()
    }
  }

  /**
   * A hashing operation that processes data to generate a hash value.
   *
   * This operation takes an input message of arbitrary content and length and produces a fixed-size
   * hash value as the output using a specified hashing algorithm.
   */
  abstract class HashOperation extends Operation, THashOperation {
    abstract override HashAlgorithm getAlgorithm();

    override string getOperationName() { result = "HashOperation" }
  }

  newtype THashType =
    MD2() or
    MD4() or
    MD5() or
    SHA1() or
    SHA2() or
    SHA3() or
    RIPEMD160() or
    WHIRLPOOL() or
    OtherHashType()

  /**
   * A hashing algorithm that transforms variable-length input into a fixed-size hash value.
   */
  abstract class HashAlgorithm extends Algorithm, THashAlgorithm {
    override string getAlgorithmType() { result = "HashAlgorithm" }

    final predicate hashTypeToNameMapping(THashType type, string name) {
      type instanceof MD2 and name = "MD2"
      or
      type instanceof MD4 and name = "MD4"
      or
      type instanceof MD5 and name = "MD5"
      or
      type instanceof SHA1 and name = "SHA1"
      or
      type instanceof SHA2 and name = "SHA2"
      or
      type instanceof SHA3 and name = "SHA3"
      or
      type instanceof RIPEMD160 and name = "RIPEMD160"
      or
      type instanceof WHIRLPOOL and name = "WHIRLPOOL"
      or
      type instanceof OtherHashType and name = this.getRawAlgorithmName()
    }

    /**
     * Gets the type of this hashing algorithm, e.g., MD5 or SHA.
     *
     * When modeling a new hashing algorithm, use this predicate to specify the type of the algorithm.
     */
    abstract THashType getHashType();

    override string getAlgorithmName() { this.hashTypeToNameMapping(this.getHashType(), result) }

    /**
     * Gets the digest size of SHA2 or SHA3 algorithms.
     *
     * This predicate does not need to hold for other algorithms,
     * as the digest size is already known based on the algorithm itself.
     *
     * For `OtherHashType` algorithms where a digest size should be reported, `THashType`
     * should be extended to explicitly model that algorithm. If the algorithm has variable
     * or multiple digest size variants, a similar predicate to this one must be defined
     * for that algorithm to report the digest size.
     */
    abstract string getSHA2OrSHA3DigestSize(Location location);

    bindingset[type]
    private string getDigestSize(THashType type, Location location) {
      type instanceof MD2 and result = "128"
      or
      type instanceof MD4 and result = "128"
      or
      type instanceof MD5 and result = "128"
      or
      type instanceof SHA1 and result = "160"
      or
      type instanceof SHA2 and result = this.getSHA2OrSHA3DigestSize(location)
      or
      type instanceof SHA3 and result = this.getSHA2OrSHA3DigestSize(location)
      or
      type instanceof RIPEMD160 and result = "160"
      or
      type instanceof WHIRLPOOL and result = "512"
    }

    final override predicate properties(string key, string value, Location location) {
      super.properties(key, value, location)
      or
      // [KNOWN_OR_UNKNOWN]
      key = "digest_size" and
      if exists(this.getDigestSize(this.getHashType(), location))
      then value = this.getDigestSize(this.getHashType(), location)
      else (
        value instanceof UnknownPropertyValue and location instanceof UnknownLocation
      )
    }
  }

  /**
   * An operation that derives one or more keys from an input value.
   */
  abstract class KeyDerivationOperation extends Operation, TKeyDerivationOperation {
    final override Location getLocation() {
      exists(LocatableElement le | this = TKeyDerivationOperation(le) and result = le.getLocation())
    }

    override string getOperationName() { result = "KeyDerivationOperation" }
  }

  /**
   * An algorithm that derives one or more keys from an input value.
   *
   * Only use this class to model UNKNOWN key derivation algorithms.
   *
   * For known algorithms, use the specialized classes, e.g., `HKDF` and `PKCS12KDF`.
   */
  abstract class KeyDerivationAlgorithm extends Algorithm, TKeyDerivationAlgorithm {
    final override Location getLocation() {
      exists(LocatableElement le | this = TKeyDerivationAlgorithm(le) and result = le.getLocation())
    }

    override string getAlgorithmType() { result = "KeyDerivationAlgorithm" }

    override string getAlgorithmName() { result = this.getRawAlgorithmName() }
  }

  /**
   * An algorithm that derives one or more keys from an input value, using a configurable digest algorithm.
   */
  abstract private class KeyDerivationWithDigestParameter extends KeyDerivationAlgorithm {
    abstract HashAlgorithm getHashAlgorithm();

    override NodeBase getChild(string edgeName) {
      result = super.getChild(edgeName)
      or
      (
        // [KNOWN_OR_UNKNOWN]
        edgeName = "uses" and
        if exists(this.getHashAlgorithm()) then result = this.getHashAlgorithm() else result = this
      )
    }
  }

  /**
   * HKDF key derivation function
   */
  abstract class HKDF extends KeyDerivationWithDigestParameter {
    final override string getAlgorithmName() { result = "HKDF" }
  }

  /**
   * PBKDF2 key derivation function
   */
  abstract class PBKDF2 extends KeyDerivationWithDigestParameter {
    final override string getAlgorithmName() { result = "PBKDF2" }

    /**
     * Gets the iteration count of this key derivation algorithm.
     */
    abstract string getIterationCount(Location location);

    /**
     * Gets the bit-length of the derived key.
     */
    abstract string getKeyLength(Location location);

    override predicate properties(string key, string value, Location location) {
      super.properties(key, value, location)
      or
      (
        // [KNOWN_OR_UNKNOWN]
        key = "iterations" and
        if exists(this.getIterationCount(location))
        then value = this.getIterationCount(location)
        else (
          value instanceof UnknownPropertyValue and location instanceof UnknownLocation
        )
      )
      or
      (
        // [KNOWN_OR_UNKNOWN]
        key = "key_len" and
        if exists(this.getKeyLength(location))
        then value = this.getKeyLength(location)
        else (
          value instanceof UnknownPropertyValue and location instanceof UnknownLocation
        )
      )
    }
  }

  /**
   * PKCS12KDF key derivation function
   */
  abstract class PKCS12KDF extends KeyDerivationWithDigestParameter {
    override string getAlgorithmName() { result = "PKCS12KDF" }

    /**
     * Gets the iteration count of this key derivation algorithm.
     */
    abstract string getIterationCount(Location location);

    /**
     * Gets the raw ID argument specifying the intended use of the derived key.
     *
     * The intended use is defined in RFC 7292, appendix B.3, as follows:
     *
     * This standard specifies 3 different values for the ID byte mentioned above:
     *
     *   1.  If ID=1, then the pseudorandom bits being produced are to be used
     *       as key material for performing encryption or decryption.
     *
     *   2.  If ID=2, then the pseudorandom bits being produced are to be used
     *       as an IV (Initial Value) for encryption or decryption.
     *
     *   3.  If ID=3, then the pseudorandom bits being produced are to be used
     *       as an integrity key for MACing.
     */
    abstract string getIDByte(Location location);

    override predicate properties(string key, string value, Location location) {
      super.properties(key, value, location)
      or
      (
        // [KNOWN_OR_UNKNOWN]
        key = "iterations" and
        if exists(this.getIterationCount(location))
        then value = this.getIterationCount(location)
        else (
          value instanceof UnknownPropertyValue and location instanceof UnknownLocation
        )
      )
      or
      (
        // [KNOWN_OR_UNKNOWN]
        key = "id_byte" and
        if exists(this.getIDByte(location))
        then value = this.getIDByte(location)
        else (
          value instanceof UnknownPropertyValue and location instanceof UnknownLocation
        )
      )
    }
  }

  /**
   * scrypt key derivation function
   */
  abstract class SCRYPT extends KeyDerivationAlgorithm {
    final override string getAlgorithmName() { result = "scrypt" }

    /**
     * Gets the iteration count (`N`) argument
     */
    abstract string get_N(Location location);

    /**
     * Gets the block size (`r`) argument
     */
    abstract string get_r(Location location);

    /**
     * Gets the parallelization factor (`p`) argument
     */
    abstract string get_p(Location location);

    /**
     * Gets the derived key length argument
     */
    abstract string getDerivedKeyLength(Location location);

    override predicate properties(string key, string value, Location location) {
      super.properties(key, value, location)
      or
      (
        // [KNOWN_OR_UNKNOWN]
        key = "N" and
        if exists(this.get_N(location))
        then value = this.get_N(location)
        else (
          value instanceof UnknownPropertyValue and location instanceof UnknownLocation
        )
      )
      or
      (
        // [KNOWN_OR_UNKNOWN]
        key = "r" and
        if exists(this.get_r(location))
        then value = this.get_r(location)
        else (
          value instanceof UnknownPropertyValue and location instanceof UnknownLocation
        )
      )
      or
      (
        // [KNOWN_OR_UNKNOWN]
        key = "p" and
        if exists(this.get_p(location))
        then value = this.get_p(location)
        else (
          value instanceof UnknownPropertyValue and location instanceof UnknownLocation
        )
      )
      or
      (
        // [KNOWN_OR_UNKNOWN]
        key = "key_len" and
        if exists(this.getDerivedKeyLength(location))
        then value = this.getDerivedKeyLength(location)
        else (
          value instanceof UnknownPropertyValue and location instanceof UnknownLocation
        )
      )
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
  newtype TEllipticCurveType =
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
    OtherEllipticCurveType()

  abstract class EllipticCurve extends Algorithm, TEllipticCurveAlgorithm {
    abstract string getKeySize(Location location);

    abstract TEllipticCurveType getCurveFamily();

    override predicate properties(string key, string value, Location location) {
      super.properties(key, value, location)
      or
      // [KNOWN_OR_UNKNOWN]
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
  newtype TModeOperationType =
    ECB() or
    CBC() or
    CFB() or
    OFB() or
    CTR() or
    GCM() or
    CCM() or
    XTS() or
    OtherMode()

  abstract class ModeOfOperation extends Algorithm {
    override string getAlgorithmType() { result = "ModeOfOperation" }

    /**
     * Gets the type of this mode of operation, e.g., "ECB" or "CBC".
     *
     * When modeling a new mode of operation, use this predicate to specify the type of the mode.
     */
    abstract TModeOperationType getModeType();

    bindingset[type]
    final predicate modeToNameMapping(TModeOperationType type, string name) {
      type instanceof ECB and name = "ECB"
      or
      type instanceof CBC and name = "CBC"
      or
      type instanceof CFB and name = "CFB"
      or
      type instanceof OFB and name = "OFB"
      or
      type instanceof CTR and name = "CTR"
      or
      type instanceof GCM and name = "GCM"
      or
      type instanceof CCM and name = "CCM"
      or
      type instanceof XTS and name = "XTS"
      or
      type instanceof OtherMode and name = this.getRawAlgorithmName()
    }

    override string getAlgorithmName() { this.modeToNameMapping(this.getModeType(), result) }
  }

  /**
   * A helper type for distinguishing between block and stream ciphers.
   */
  newtype TCipherStructureType =
    Block() or
    Stream() or
    UnknownCipherStructureType()

  private string getCipherStructureTypeString(TCipherStructureType type) {
    type instanceof Block and result = "Block"
    or
    type instanceof Stream and result = "Stream"
    or
    type instanceof UnknownCipherStructureType and result instanceof UnknownPropertyValue
  }

  /**
   * Symmetric algorithms
   */
  newtype TSymmetricCipherType =
    AES() or
    Camellia() or
    DES() or
    TripleDES() or
    IDEA() or
    CAST5() or
    ChaCha20() or
    RC4() or
    RC5() or
    OtherSymmetricCipherType()

  abstract class SymmetricAlgorithm extends Algorithm {
    final TCipherStructureType getCipherStructure() {
      this.cipherFamilyToNameAndStructure(this.getCipherFamily(), _, result)
    }

    final override string getAlgorithmName() {
      this.cipherFamilyToNameAndStructure(this.getCipherFamily(), result, _)
    }

    final override string getAlgorithmType() { result = "SymmetricAlgorithm" }

    /**
     * Gets the key size of this symmetric cipher, e.g., "128" or "256".
     */
    abstract string getKeySize(Location location);

    /**
     * Gets the type of this symmetric cipher, e.g., "AES" or "ChaCha20".
     */
    abstract TSymmetricCipherType getCipherFamily();

    /**
     * Gets the mode of operation of this symmetric cipher, e.g., "GCM" or "CBC".
     */
    abstract ModeOfOperation getModeOfOperation();

    bindingset[type]
    final private predicate cipherFamilyToNameAndStructure(
      TSymmetricCipherType type, string name, TCipherStructureType s
    ) {
      type instanceof AES and name = "AES" and s = Block()
      or
      type instanceof Camellia and name = "Camellia" and s = Block()
      or
      type instanceof DES and name = "DES" and s = Block()
      or
      type instanceof TripleDES and name = "TripleDES" and s = Block()
      or
      type instanceof IDEA and name = "IDEA" and s = Block()
      or
      type instanceof CAST5 and name = "CAST5" and s = Block()
      or
      type instanceof ChaCha20 and name = "ChaCha20" and s = Stream()
      or
      type instanceof RC4 and name = "RC4" and s = Stream()
      or
      type instanceof RC5 and name = "RC5" and s = Block()
      or
      type instanceof OtherSymmetricCipherType and
      name = this.getRawAlgorithmName() and
      s = UnknownCipherStructureType()
    }

    //mode, padding scheme, keysize, block/stream, auth'd
    //nodes = mode, padding scheme
    //properties = keysize, block/stream, auth'd
    //leave authd to lang specific
    override NodeBase getChild(string edgeName) {
      result = super.getChild(edgeName)
      or
      (
        // [KNOWN_OR_UNKNOWN]
        edgeName = "mode" and
        if exists(this.getModeOfOperation())
        then result = this.getModeOfOperation()
        else result = this
      )
    }

    override predicate properties(string key, string value, Location location) {
      super.properties(key, value, location)
      or
      // [ALWAYS_KNOWN]: unknown case is handled in `getCipherStructureTypeString`
      key = "structure" and
      getCipherStructureTypeString(this.getCipherStructure()) = value and
      location instanceof UnknownLocation
      or
      (
        // [KNOWN_OR_UNKNOWN]
        key = "key_size" and
        if exists(this.getKeySize(location))
        then value = this.getKeySize(location)
        else (
          value instanceof UnknownPropertyValue and location instanceof UnknownLocation
        )
      )
    }
  }
}
