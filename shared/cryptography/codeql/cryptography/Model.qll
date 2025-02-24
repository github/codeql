/**
 * A language-independent library for reasoning about cryptography.
 */

import codeql.util.Location
import codeql.util.Option

signature module InputSig<LocationSig Location> {
  class LocatableElement {
    Location getLocation();

    string toString();
  }

  class DataFlowNode {
    Location getLocation();

    string toString();
  }

  class UnknownLocation instanceof Location;
}

module CryptographyBase<LocationSig Location, InputSig<Location> Input> {
  final class LocatableElement = Input::LocatableElement;

  final class UnknownLocation = Input::UnknownLocation;

  final class DataFlowNode = Input::DataFlowNode;

  final class UnknownPropertyValue extends string {
    UnknownPropertyValue() { this = "<unknown>" }
  }

  private string getPropertyAsGraphString(NodeBase node, string key, Location root) {
    result =
      strictconcat(any(string value, Location location, string parsed |
            node.properties(key, value, location) and
            if location = root or location instanceof UnknownLocation
            then parsed = value
            else parsed = "(" + value + "," + location.toString() + ")"
          |
            parsed
          ), ","
      )
  }

  predicate nodes_graph_impl(NodeBase node, string key, string value) {
    not (
      // exclude Artifact nodes with no edges to or from them
      node instanceof Artifact and
      not (edges_graph_impl(node, _, _, _) or edges_graph_impl(_, node, _, _))
    ) and
    (
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
      value = getPropertyAsGraphString(node, key, node.getLocation())
    )
  }

  predicate edges_graph_impl(NodeBase source, NodeBase target, string key, string value) {
    key = "semmle.label" and
    target = source.getChild(value) and
    // Known unknowns are reported as properties rather than edges
    not source = target
  }

  /**
   * All elements in the database that are mapped to nodes must extend the following classes
   */
  abstract class HashOperationInstance extends LocatableElement { }

  abstract class HashAlgorithmInstance extends LocatableElement { }

  abstract class KeyDerivationOperationInstance extends LocatableElement { }

  abstract class KeyDerivationAlgorithmInstance extends LocatableElement { }

  abstract class CipherOperationInstance extends LocatableElement {
    abstract CipherAlgorithmInstance getAlgorithm();

    abstract CipherOperationSubtype getCipherOperationSubtype();

    abstract NonceArtifactInstance getNonce();

    abstract DataFlowNode getInputData();
  }

  abstract class CipherAlgorithmInstance extends LocatableElement { }

  abstract class KeyEncapsulationOperationInstance extends LocatableElement { }

  abstract class KeyEncapsulationAlgorithmInstance extends LocatableElement { }

  abstract class EllipticCurveAlgorithmInstance extends LocatableElement { }

  // Non-standalone algorithms
  abstract class BlockCipherModeOfOperationAlgorithmInstance extends LocatableElement { }

  abstract class PaddingAlgorithmInstance extends LocatableElement { }

  // Artifacts
  abstract private class ArtifactLocatableElement extends LocatableElement {
    abstract DataFlowNode asOutputData();

    abstract DataFlowNode getInput();
  }

  abstract class DigestArtifactInstance extends ArtifactLocatableElement { }

  abstract class KeyMaterialInstance extends ArtifactLocatableElement { }

  abstract class KeyArtifactInstance extends ArtifactLocatableElement { }

  abstract class NonceArtifactInstance extends ArtifactLocatableElement { }

  abstract class RandomNumberGenerationInstance extends ArtifactLocatableElement {
    final override DataFlowNode getInput() { none() }
  }

  newtype TNode =
    // Artifacts (data that is not an operation or algorithm, e.g., a key)
    TDigest(DigestArtifactInstance e) or
    TKey(KeyArtifactInstance e) or
    TKeyMaterial(KeyMaterialInstance e) or
    TNonce(NonceArtifactInstance e) or
    TRandomNumberGeneration(RandomNumberGenerationInstance e) or
    // Operations (e.g., hashing, encryption)
    THashOperation(HashOperationInstance e) or
    TKeyDerivationOperation(KeyDerivationOperationInstance e) or
    TCipherOperation(CipherOperationInstance e) or
    TKeyEncapsulationOperation(KeyEncapsulationOperationInstance e) or
    // Algorithms (e.g., SHA-256, AES)
    TCipherAlgorithm(CipherAlgorithmInstance e) or
    TEllipticCurveAlgorithm(EllipticCurveAlgorithmInstance e) or
    THashAlgorithm(HashAlgorithmInstance e) or
    TKeyDerivationAlgorithm(KeyDerivationAlgorithmInstance e) or
    TKeyEncapsulationAlgorithm(KeyEncapsulationAlgorithmInstance e) or
    // Non-standalone Algorithms (e.g., Mode, Padding)
    // TODO: need to rename this, as "mode" is getting reused in different contexts, be precise
    TBlockCipherModeOfOperationAlgorithm(BlockCipherModeOfOperationAlgorithmInstance e) or
    TPaddingAlgorithm(PaddingAlgorithmInstance e) or
    // Composite and hybrid cryptosystems (e.g., RSA-OAEP used with AES, post-quantum hybrid cryptosystems)
    // These nodes are always parent nodes and are not modeled but rather defined via library-agnostic patterns.
    TKemDemHybridCryptosystem(CipherAlgorithm dem) or // TODO, change this relation and the below ones
    TKeyAgreementHybridCryptosystem(CipherAlgorithmInstance ka) or
    TAsymmetricEncryptionMacHybridCryptosystem(CipherAlgorithmInstance enc) or
    TPostQuantumHybridCryptosystem(CipherAlgorithmInstance enc)

  /**
   * The base class for all cryptographic assets, such as operations and algorithms.
   *
   * Each `NodeBase` is a node in a graph of cryptographic operations, where the edges are the relationships between the nodes.
   */
  abstract class NodeBase extends TNode {
    /**
     * Returns a string representation of this node.
     */
    string toString() { result = this.getInternalType() }

    /**
     * Returns a string representation of the internal type of this node, usually the name of the class.
     */
    abstract string getInternalType();

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
     * This predicate is overriden by derived classes to construct the graph of cryptographic operations.
     */
    NodeBase getChild(string edgeName) { none() }

    /**
     * Defines properties of this node by name and either a value or location or both.
     *
     * This predicate is overriden by derived classes to construct the graph of cryptographic operations.
     */
    predicate properties(string key, string value, Location location) {
      key = "origin" and
      location = this.getOrigin(value).getLocation() and
      not location = this.getLocation()
    }

    /**
     * Returns a parent of this node.
     */
    final NodeBase getAParent() { result.getChild(_) = this }
  }

  class Asset = NodeBase;

  abstract class Artifact extends NodeBase {
    abstract DataFlowNode asOutputData();

    abstract DataFlowNode getInputData();
  }

  /**
   * A nonce or initialization vector
   */
  private class NonceImpl extends Artifact, TNonce {
    NonceArtifactInstance instance;

    NonceImpl() { this = TNonce(instance) }

    final override string getInternalType() { result = "Nonce" }

    override Location getLocation() { result = instance.getLocation() }

    override DataFlowNode asOutputData() { result = instance.asOutputData() }

    override DataFlowNode getInputData() { result = instance.getInput() }
  }

  final class Nonce = NonceImpl;

  /**
   * A source of random number generation
   */
  final private class RandomNumberGenerationImpl extends Artifact, TRandomNumberGeneration {
    RandomNumberGenerationInstance instance;

    RandomNumberGenerationImpl() { this = TRandomNumberGeneration(instance) }

    final override string getInternalType() { result = "RandomNumberGeneration" }

    override Location getLocation() { result = instance.getLocation() }

    override DataFlowNode asOutputData() { result = instance.asOutputData() }

    override DataFlowNode getInputData() { result = instance.getInput() }
  }

  final class RandomNumberGeneration = RandomNumberGenerationImpl;

  /**
   * A cryptographic operation, such as hashing or encryption.
   */
  abstract class Operation extends Asset {
    /**
     * Gets the algorithm associated with this operation.
     */
    abstract Algorithm getAlgorithm();

    override NodeBase getChild(string edgeName) {
      result = super.getChild(edgeName)
      or
      edgeName = "uses" and
      if exists(this.getAlgorithm()) then result = this.getAlgorithm() else result = this
    }
  }

  abstract class Algorithm extends Asset {
    final override string getInternalType() { result = this.getAlgorithmType() }

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
    //override string getOperationType() { result = "HashOperation" }
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
    private string getTypeDigestSizeFixed(THashType type) {
      type instanceof MD2 and result = "128"
      or
      type instanceof MD4 and result = "128"
      or
      type instanceof MD5 and result = "128"
      or
      type instanceof SHA1 and result = "160"
      or
      type instanceof RIPEMD160 and result = "160"
      or
      type instanceof WHIRLPOOL and result = "512"
    }

    bindingset[type]
    private string getTypeDigestSize(THashType type, Location location) {
      result = this.getTypeDigestSizeFixed(type) and location = this.getLocation()
      or
      type instanceof SHA2 and result = this.getSHA2OrSHA3DigestSize(location)
      or
      type instanceof SHA3 and result = this.getSHA2OrSHA3DigestSize(location)
    }

    string getDigestSize(Location location) {
      result = this.getTypeDigestSize(this.getHashType(), location)
    }

    final override predicate properties(string key, string value, Location location) {
      super.properties(key, value, location)
      or
      // [KNOWN_OR_UNKNOWN]
      key = "digest_size" and
      if exists(this.getDigestSize(location))
      then value = this.getDigestSize(location)
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
    //override string getOperationType() { result = "KeyDerivationOperation" }
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

  newtype TCipherOperationSubtype =
    TEncryptionMode() or
    TDecryptionMode() or
    TWrapMode() or
    TUnwrapMode() or
    TUnknownCipherOperationMode()

  abstract class CipherOperationSubtype extends TCipherOperationSubtype {
    abstract string toString();
  }

  class EncryptionMode extends CipherOperationSubtype, TEncryptionMode {
    override string toString() { result = "Encrypt" }
  }

  class DecryptionMode extends CipherOperationSubtype, TDecryptionMode {
    override string toString() { result = "Decrypt" }
  }

  class WrapMode extends CipherOperationSubtype, TWrapMode {
    override string toString() { result = "Wrap" }
  }

  class UnwrapMode extends CipherOperationSubtype, TUnwrapMode {
    override string toString() { result = "Unwrap" }
  }

  class UnknownCipherOperationMode extends CipherOperationSubtype, TUnknownCipherOperationMode {
    override string toString() { result = "Unknown" }
  }

  /**
   * An encryption operation that processes plaintext to generate a ciphertext.
   * This operation takes an input message (plaintext) of arbitrary content and length
   * and produces a ciphertext as the output using a specified encryption algorithm (with a mode and padding).
   */
  class CipherOperationImpl extends Operation, TCipherOperation {
    CipherOperationInstance instance;

    CipherOperationImpl() { this = TCipherOperation(instance) }

    override string getInternalType() { result = "CipherOperation" }

    override Location getLocation() { result = instance.getLocation() }

    CipherOperationSubtype getCipherOperationMode() {
      result = instance.getCipherOperationSubtype()
    }

    final override CipherAlgorithm getAlgorithm() { result.getInstance() = instance.getAlgorithm() }

    override NodeBase getChild(string key) {
      result = super.getChild(key)
      or
      // [KNOWN_OR_UNKNOWN]
      key = "nonce" and
      if exists(this.getNonce()) then result = this.getNonce() else result = this
    }

    override predicate properties(string key, string value, Location location) {
      super.properties(key, value, location)
      or
      // [ALWAYS_KNOWN] - Unknown is handled in getCipherOperationMode()
      key = "operation" and
      value = this.getCipherOperationMode().toString() and
      location = this.getLocation()
    }

    /**
     * Gets the initialization vector associated with this encryption operation.
     *
     * This predicate does not need to hold for all encryption operations,
     * as the initialization vector is not always required.
     */
    Nonce getNonce() { result = TNonce(instance.getNonce()) }

    DataFlowNode getInputData() { result = instance.getInputData() }
  }

  final class CipherOperation = CipherOperationImpl;

  /**
   * Block cipher modes of operation algorithms
   */
  newtype TBlockCipherModeOperationType =
    ECB() or // Not secure, widely used
    CBC() or // Vulnerable to padding oracle attacks
    GCM() or // Widely used AEAD mode (TLS 1.3, SSH, IPsec)
    CTR() or // Fast stream-like encryption (SSH, disk encryption)
    XTS() or // Standard for full-disk encryption (BitLocker, LUKS, FileVault)
    CCM() or // Used in lightweight cryptography (IoT, WPA2)
    SIV() or // Misuse-resistant encryption, used in secure storage
    OCB() or // Efficient AEAD mode
    OtherMode()

  abstract class ModeOfOperationAlgorithm extends Algorithm, TBlockCipherModeOfOperationAlgorithm {
    override string getAlgorithmType() { result = "ModeOfOperation" }

    /**
     * Gets the type of this mode of operation, e.g., "ECB" or "CBC".
     *
     * When modeling a new mode of operation, use this predicate to specify the type of the mode.
     *
     * If a type cannot be determined, the result is `OtherMode`.
     */
    abstract TBlockCipherModeOperationType getModeType();

    bindingset[type]
    final private predicate modeToNameMapping(TBlockCipherModeOperationType type, string name) {
      type instanceof ECB and name = "ECB"
      or
      type instanceof CBC and name = "CBC"
      or
      type instanceof GCM and name = "GCM"
      or
      type instanceof CTR and name = "CTR"
      or
      type instanceof XTS and name = "XTS"
      or
      type instanceof CCM and name = "CCM"
      or
      type instanceof SIV and name = "SIV"
      or
      type instanceof OCB and name = "OCB"
      or
      type instanceof OtherMode and name = this.getRawAlgorithmName()
    }

    override string getAlgorithmName() { this.modeToNameMapping(this.getModeType(), result) }
  }

  newtype TPaddingType =
    PKCS1_v1_5() or // RSA encryption/signing padding
    PKCS7() or // Standard block cipher padding (PKCS5 for 8-byte blocks)
    ANSI_X9_23() or // Zero-padding except last byte = padding length
    NoPadding() or // Explicit no-padding
    OAEP() or // RSA OAEP padding
    OtherPadding()

  abstract class PaddingAlgorithm extends Algorithm, TPaddingAlgorithm {
    override string getAlgorithmType() { result = "PaddingAlgorithm" }

    /**
     * Gets the type of this padding algorithm, e.g., "PKCS7" or "OAEP".
     *
     * When modeling a new padding algorithm, use this predicate to specify the type of the padding.
     *
     * If a type cannot be determined, the result is `OtherPadding`.
     */
    abstract TPaddingType getPaddingType();

    bindingset[type]
    final private predicate paddingToNameMapping(TPaddingType type, string name) {
      type instanceof PKCS1_v1_5 and name = "PKCS1_v1_5"
      or
      type instanceof PKCS7 and name = "PKCS7"
      or
      type instanceof ANSI_X9_23 and name = "ANSI_X9_23"
      or
      type instanceof NoPadding and name = "NoPadding"
      or
      type instanceof OAEP and name = "OAEP"
      or
      type instanceof OtherPadding and name = this.getRawAlgorithmName()
    }

    override string getAlgorithmName() { this.paddingToNameMapping(this.getPaddingType(), result) }
  }

  /**
   * A helper type for distinguishing between block and stream ciphers.
   */
  newtype TCipherStructureType =
    Block() or
    Stream() or
    Asymmetric() or
    UnknownCipherStructureType()

  private string getCipherStructureTypeString(TCipherStructureType type) {
    type instanceof Block and result = "Block"
    or
    type instanceof Stream and result = "Stream"
    or
    type instanceof Asymmetric and result = "Asymmetric"
    or
    type instanceof UnknownCipherStructureType and result instanceof UnknownPropertyValue
  }

  /**
   * Symmetric algorithms
   */
  newtype TCipherType =
    AES() or
    Camellia() or
    DES() or
    TripleDES() or
    IDEA() or
    CAST5() or
    ChaCha20() or
    RC4() or
    RC5() or
    RSA() or
    OtherCipherType()

  abstract class CipherAlgorithm extends Algorithm, TCipherAlgorithm {
    final LocatableElement getInstance() { this = TCipherAlgorithm(result) }

    final TCipherStructureType getCipherStructure() {
      this.cipherFamilyToNameAndStructure(this.getCipherFamily(), _, result)
    }

    final override string getAlgorithmName() {
      this.cipherFamilyToNameAndStructure(this.getCipherFamily(), result, _)
    }

    override string getAlgorithmType() { result = "CipherAlgorithm" }

    /**
     * Gets the key size of this cipher, e.g., "128" or "256".
     */
    abstract string getKeySize(Location location);

    /**
     * Gets the type of this cipher, e.g., "AES" or "ChaCha20".
     */
    abstract TCipherType getCipherFamily();

    /**
     * Gets the mode of operation of this cipher, e.g., "GCM" or "CBC".
     */
    abstract ModeOfOperationAlgorithm getModeOfOperation();

    /**
     * Gets the padding scheme of this cipher, e.g., "PKCS7" or "NoPadding".
     */
    abstract PaddingAlgorithm getPadding();

    bindingset[type]
    final private predicate cipherFamilyToNameAndStructure(
      TCipherType type, string name, TCipherStructureType s
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
      type instanceof RSA and name = "RSA" and s = Asymmetric()
      or
      type instanceof OtherCipherType and
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
      // [KNOWN_OR_UNKNOWN]
      edgeName = "mode" and
      if exists(this.getModeOfOperation())
      then result = this.getModeOfOperation()
      else result = this
      or
      // [KNOWN_OR_UNKNOWN]
      edgeName = "padding" and
      if exists(this.getPadding()) then result = this.getPadding() else result = this
    }

    override predicate properties(string key, string value, Location location) {
      super.properties(key, value, location)
      or
      // [ALWAYS_KNOWN] - unknown case is handled in `getCipherStructureTypeString`
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

  abstract class KEMAlgorithm extends TKeyEncapsulationAlgorithm, Algorithm {
    final override string getAlgorithmType() { result = "KeyEncapsulationAlgorithm" }
  }

  /**
   * A Key Material Object
   */
  private class KeyMaterialImpl extends Artifact, TKeyMaterial {
    KeyMaterialInstance instance;

    KeyMaterialImpl() { this = TKeyMaterial(instance) }

    final override string getInternalType() { result = "KeyMaterial" }

    override Location getLocation() { result = instance.getLocation() }

    override DataFlowNode asOutputData() { result = instance.asOutputData() }

    override DataFlowNode getInputData() { result = instance.getInput() }
  }

  final class KeyMaterial = KeyMaterialImpl;
}
