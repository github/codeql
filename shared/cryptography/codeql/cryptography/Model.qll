/**
 * A language-independent library for reasoning about cryptography.
 */

import codeql.util.Location
import codeql.util.Option
import codeql.util.Either

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

  string locationToFileBaseNameAndLineNumberString(Location location);

  LocatableElement dfn_to_element(DataFlowNode node);

  predicate artifactOutputFlowsToGenericInput(
    DataFlowNode artifactOutput, DataFlowNode otherFlowAwareInput
  );
}

module CryptographyBase<LocationSig Location, InputSig<Location> Input> {
  final class LocatableElement = Input::LocatableElement;

  final class UnknownLocation = Input::UnknownLocation;

  final class DataFlowNode = Input::DataFlowNode;

  class ConsumerInputDataFlowNode extends DataFlowNode {
    ConsumerElement getConsumer() { result.getInputNode() = this }
  }

  class ArtifactOutputDataFlowNode extends DataFlowNode {
    OutputArtifactInstance getArtifact() { result.getOutputNode() = this }
  }

  final class UnknownPropertyValue extends string {
    UnknownPropertyValue() { this = "<unknown>" }
  }

  bindingset[root]
  private string getPropertyAsGraphString(NodeBase node, string key, Location root) {
    result =
      strictconcat(any(string value, Location location, string parsed |
            node.properties(key, value, location) and
            (
              if location = root or location instanceof UnknownLocation
              then parsed = value
              else
                parsed =
                  "(" + value + "," + Input::locationToFileBaseNameAndLineNumberString(location) +
                    ")"
            )
          |
            parsed
          ), ","
      )
  }

  bindingset[node]
  predicate node_as_property(GenericSourceNode node, string value, Location location) {
    value =
      node.getInternalType() + ":" +
        node.asElement().(GenericSourceInstance).getAdditionalDescription() and
    location = node.getLocation()
  }

  NodeBase getPassthroughNodeChild(NodeBase node) { result = node.getChild(_) }

  predicate isPassthroughNodeWithSource(NodeBase node) {
    isPassthroughNode(node) and
    exists(node.asElement().(ArtifactConsumerAndInstance).getASource())
  }

  predicate isPassthroughNode(NodeBase node) {
    node.asElement() instanceof ArtifactConsumerAndInstance
  }

  predicate nodes_graph_impl(NodeBase node, string key, string value) {
    not node.isExcludedFromGraph() and
    not isPassthroughNodeWithSource(node) and // TODO: punt to fix known unknowns for passthrough nodes
    (
      key = "semmle.label" and
      value = node.toString()
      or
      // CodeQL's DGML output does not include a location
      key = "Location" and
      value = Input::locationToFileBaseNameAndLineNumberString(node.getLocation()) // node.getLocation().toString()
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
    exists(NodeBase directTarget |
      directTarget = source.getChild(value) and
      // [NodeA] ---Input--> [Passthrough] ---Source---> [NodeB]
      // should get reported as [NodeA] ---Input--> [NodeB]
      if isPassthroughNode(directTarget)
      then target = getPassthroughNodeChild(directTarget)
      else target = directTarget
    ) and
    // Known unknowns are reported as properties rather than edges
    not source = target
  }

  /**
   * An element that is flow-aware, i.e., it has an input and output node implicitly used for data flow analysis.
   */
  abstract class FlowAwareElement extends LocatableElement {
    /**
     * Gets the output node for this element, which should usually be the same as `this`.
     */
    abstract DataFlowNode getOutputNode();

    /**
     * Gets the input node for this element which takes in data.
     *
     * If `getInput` is implemented as `none()`, the artifact will not have inbound flow analysis.
     */
    abstract ConsumerInputDataFlowNode getInputNode();

    /**
     * Holds if this element flows to `other`.
     *
     * This predicate should be defined generically per-language with library-specific extension support.
     * The expected implementation is to perform flow analysis from this element's output to another element's input.
     * The `other` argument should be one or more `FlowAwareElement`s that are sinks of the flow.
     *
     * If `flowsTo` is implemented as `none()`, the artifact will not have outbound flow analysis.
     */
    abstract predicate flowsTo(FlowAwareElement other);
  }

  /**
   * An element that represents a _known_ cryptographic asset with a determinable value OR an artifact.
   *
   * CROSS PRODUCT WARNING: Modeling any *other* element that is a `FlowAwareElement` to the same
   * instance in the database will result in every `FlowAwareElement` sharing the output flow.
   */
  abstract class KnownElement extends LocatableElement {
    final ConsumerElement getAConsumer() { result.getAKnownSource() = this }
  }

  /**
   * An element that represents a _known_ cryptographic operation.
   */
  abstract class OperationInstance extends KnownElement {
    /**
     * Gets the consumers of algorithm values associated with this operation.
     */
    abstract AlgorithmValueConsumer getAnAlgorithmValueConsumer();
  }

  /**
   * An element that represents a _known_ cryptographic algorithm.
   */
  abstract class AlgorithmInstance extends KnownElement { }

  /**
   * An element that represents a generic source of data.
   *
   * A generic source of data is either:
   * 1. A value (e.g., a string or integer literal) *or*
   * 1. An input for which a value cannot be determined (e.g., `argv`, file system reads, and web request headers)
   */
  abstract class GenericSourceInstance extends FlowAwareElement {
    final override ConsumerInputDataFlowNode getInputNode() { none() }

    abstract string getInternalType();

    string getAdditionalDescription() { none() }
  }

  /**
   * An element that has a constant value and is a generic source of data.
   */
  abstract class GenericValueSourceInstance extends GenericSourceInstance { }

  /**
   * An element with a constant value, such as a literal.
   */
  abstract class GenericConstantSourceInstance extends GenericValueSourceInstance {
    final override string getInternalType() { result = "Constant" }
  }

  /**
   * An element representing statically or dynamically allocated data.
   */
  abstract class GenericAllocationSourceInstance extends GenericValueSourceInstance {
    final override string getInternalType() { result = "Allocation" }
  }

  /**
   * An element that does not have a determinable constant value and is a generic source of data.
   */
  abstract class GenericNoValueSourceInstance extends GenericSourceInstance { }

  /**
   * A call to or an output argument of an external function with no definition.
   */
  abstract class GenericExternalCallSource extends GenericNoValueSourceInstance {
    final override string getInternalType() { result = "ExternalCall" } // TODO: call target name or toString of source?
  }

  /**
   * A parameter of a function which has no identifiable callsite.
   */
  abstract class GenericUnreferencedParameterSource extends GenericNoValueSourceInstance {
    final override string getInternalType() { result = "Parameter" } // TODO: toString of source?
  }

  /**
   * A source of remote or external data, such as web request headers.
   */
  abstract class GenericRemoteDataSource extends GenericNoValueSourceInstance {
    // TODO: avoid duplication with the above types?.. perhaps define the above generically then override
    final override string getInternalType() { result = "RemoteData" } // TODO: toString of source?
  }

  /**
   * A source of local or environment data, such as environment variables or a local filesystem.
   */
  abstract class GenericLocalDataSource extends GenericNoValueSourceInstance {
    // TODO: avoid duplication with the above types
    final override string getInternalType() { result = "LocalData" } // TODO: toString of source?
  }

  /**
   * An element that consumes _known_ or _unknown_ cryptographic assets.
   *
   * Note that known assets are to be modeled explicitly with the `getAKnownSource` predicate, whereas
   * unknown assets are modeled implicitly via flow analysis from any `GenericSourceInstance` to this element.
   *
   * A consumer can consume multiple instances and types of assets at once, e.g., both a `PaddingAlgorithm` and `CipherAlgorithm`.
   */
  abstract private class ConsumerElement extends FlowAwareElement {
    abstract KnownElement getAKnownSource();

    override predicate flowsTo(FlowAwareElement other) { none() }

    override DataFlowNode getOutputNode() { none() }

    final GenericSourceInstance getAGenericSource() {
      result.flowsTo(this) and not result = this.getAKnownSource()
    }

    final GenericSourceNode getAGenericSourceNode() {
      result.asElement() = this.getAGenericSource()
    }

    final NodeBase getAKnownSourceNode() { result.asElement() = this.getAKnownSource() }

    final LocatableElement getASource() {
      result = this.getAGenericSource() or
      result = this.getAKnownSource()
    }
  }

  /**
   * A generic value consumer, e.g. for inputs such as key length.
   * TODO: type hints or per-instantiation type hint config on the source/sink pairs.
   */
  final private class GenericValueConsumer extends ConsumerElement {
    ConsumerInputDataFlowNode input;

    GenericValueConsumer() {
      (
        exists(KeyCreationOperationInstance op | input = op.getKeySizeConsumer())
        or
        exists(KeyDerivationOperationInstance op |
          input = op.getIterationCountConsumer() or
          input = op.getOutputKeySizeConsumer()
        )
      ) and
      this = Input::dfn_to_element(input)
    }

    final override KnownElement getAKnownSource() { none() }

    final override ConsumerInputDataFlowNode getInputNode() { result = input }
  }

  abstract class AlgorithmValueConsumer extends ConsumerElement {
    /**
     * DO NOT USE.
     * Model `getAKnownAlgorithmSource()` instead, which is equivalent but correctly typed.
     */
    final override KnownElement getAKnownSource() { result = this.getAKnownAlgorithmSource() }

    /**
     * Gets a known algorithm value that is equivalent to or consumed by this element.
     */
    abstract AlgorithmInstance getAKnownAlgorithmSource();
  }

  /**
   * An element that represents a _known_ cryptographic artifact.
   */
  abstract class ArtifactInstance extends KnownElement, FlowAwareElement {
    abstract predicate isConsumerArtifact(); // whether this is an input artifact defined by its consumer
  }

  /**
   * An `ArtifactConsumer` represents an element in code that consumes an artifact.
   *
   * The concept of "`ArtifactConsumer` = `ArtifactNode`" should be used for inputs, as a consumer can be directly tied
   * to the artifact it receives, thereby becoming the definitive contextual source for that artifact.
   *
   * Architectural Implications:
   *   * By directly coupling a consumer with the node that receives an artifact,
   *     the data flow is fully transparent with the consumer itself serving only as a transparent node.
   *   * An artifact's properties (such as being a nonce) are not necessarily inherent; they are determined by the context in which the artifact is consumed.
   *     The consumer node is therefore essential in defining these properties for inputs.
   *   * This approach reduces ambiguity by avoiding separate notions of "artifact source" and "consumer", as the node itself encapsulates both roles.
   *   * Instances of nodes do not necessarily have to come from a consumer, allowing additional modelling of an artifact to occur outside of the consumer.
   */
  abstract class ArtifactConsumer extends ConsumerElement {
    /**
     * DO NOT USE:
     * Use `getAKnownArtifactSource() instead. The behaviour of these two predicates is equivalent.
     */
    final override KnownElement getAKnownSource() { result = this.getAKnownArtifactSource() }

    final ArtifactInstance getAKnownArtifactSource() { result.flowsTo(this) }
  }

  /**
   * An `ArtifactConsumer` that is also an `ArtifactInstance`.
   *
   * For example:
   * A `NonceArtifactConsumer` is always the `NonceArtifactInstance` itself, since data only becomes (i.e., is determined to be)
   * a `NonceArtifactInstance` when it is consumed in a context that expects a nonce (e.g., an argument expecting nonce data).
   * In this case, the artifact (nonce) is fully defined by the context in which it is consumed, and the consumer embodies
   * that identity without the need for additional differentiation. Without the context a consumer provides, that data could
   * otherwise be any other type of artifact or even simply random data.
   *
   * TODO: what if a Nonce from hypothetical func `generateNonce()` flows to this instance which is also a Nonce?
   * TODO: potential solution is creating another artifact type called NonceData or treating it as a generic source.
   *
   * TODO: An alternative is simply having a predicate DataFlowNode getNonceInputNode() on (for example) operations.
   *       Under the hood, in Model.qll, we would create the instance for the modeller, thus avoiding the need for the modeller
   *       to create a separate consumer class / instance themselves using this class.
   */
  abstract private class ArtifactConsumerAndInstance extends ArtifactConsumer, ArtifactInstance {
    override predicate isConsumerArtifact() { any() }
  }

  final private class NonceArtifactConsumer extends ArtifactConsumerAndInstance {
    ConsumerInputDataFlowNode inputNode;

    NonceArtifactConsumer() {
      exists(CipherOperationInstance op | inputNode = op.getNonceConsumer()) and
      this = Input::dfn_to_element(inputNode)
    }

    final override ConsumerInputDataFlowNode getInputNode() { result = inputNode }
  }

  final private class MessageArtifactConsumer extends ArtifactConsumerAndInstance {
    ConsumerInputDataFlowNode inputNode;

    MessageArtifactConsumer() {
      (
        exists(CipherOperationInstance op | inputNode = op.getInputConsumer())
        or
        exists(KeyDerivationOperationInstance op | inputNode = op.getInputConsumer())
        or
        exists(MACOperationInstance op | inputNode = op.getMessageConsumer())
      ) and
      this = Input::dfn_to_element(inputNode)
    }

    final override ConsumerInputDataFlowNode getInputNode() { result = inputNode }
  }

  final private class SaltArtifactConsumer extends ArtifactConsumerAndInstance {
    ConsumerInputDataFlowNode inputNode;

    SaltArtifactConsumer() {
      exists(KeyDerivationOperationInstance op | inputNode = op.getSaltConsumer()) and
      this = Input::dfn_to_element(inputNode)
    }

    final override ConsumerInputDataFlowNode getInputNode() { result = inputNode }
  }

  // Output artifacts are determined solely by the element that produces them.
  abstract class OutputArtifactInstance extends ArtifactInstance {
    override predicate isConsumerArtifact() { none() }

    override ConsumerInputDataFlowNode getInputNode() { none() }

    final override predicate flowsTo(FlowAwareElement other) {
      Input::artifactOutputFlowsToGenericInput(this.getOutputNode(), other.getInputNode())
    }
  }

  abstract class DigestArtifactInstance extends OutputArtifactInstance { }

  abstract class RandomNumberGenerationInstance extends OutputArtifactInstance {
    // TODO: input seed?
  }

  abstract class CipherOutputArtifactInstance extends OutputArtifactInstance { }

  // Artifacts that may be outputs or inputs
  newtype TKeyArtifactType =
    TSymmetricKeyType() or
    TAsymmetricKeyType() or
    TUnknownKeyType()

  class KeyArtifactType extends TKeyArtifactType {
    string toString() {
      this = TSymmetricKeyType() and result = "Symmetric"
      or
      this = TAsymmetricKeyType() and result = "Asymmetric"
      or
      this = TUnknownKeyType() and result = "Unknown"
    }
  }

  abstract private class KeyArtifactInstance extends ArtifactInstance {
    abstract KeyArtifactType getKeyType();
  }

  final class KeyArtifactOutputInstance extends KeyArtifactInstance, OutputArtifactInstance {
    KeyCreationOperationInstance creator;

    KeyArtifactOutputInstance() { Input::dfn_to_element(creator.getOutputKeyArtifact()) = this }

    final KeyCreationOperationInstance getCreator() { result = creator }

    override KeyArtifactType getKeyType() { result = creator.getOutputKeyType() }

    override DataFlowNode getOutputNode() { result = creator.getOutputKeyArtifact() }
  }

  final class KeyArtifactConsumer extends KeyArtifactInstance, ArtifactConsumerAndInstance {
    ConsumerInputDataFlowNode inputNode;

    // TODO: key type hint? e.g. hint: private || public
    KeyArtifactConsumer() {
      (
        exists(CipherOperationInstance op | inputNode = op.getKeyConsumer()) or
        exists(MACOperationInstance op | inputNode = op.getKeyConsumer())
      ) and
      this = Input::dfn_to_element(inputNode)
    }

    override KeyArtifactType getKeyType() { result instanceof TUnknownKeyType } // A consumer node does not have a key type, refer to source (TODO: refine, should this be none())

    final override ConsumerInputDataFlowNode getInputNode() { result = inputNode }
  }

  /**
   * A cipher operation instance, such as encryption or decryption.
   */
  abstract class CipherOperationInstance extends OperationInstance {
    /**
     * Gets the subtype of this cipher operation, distinguishing encryption, decryption, key wrapping, and key unwrapping.
     */
    abstract CipherOperationSubtype getCipherOperationSubtype();

    /**
     * Gets the consumer of nonces/IVs associated with this cipher operation.
     */
    abstract ConsumerInputDataFlowNode getNonceConsumer();

    /**
     * Gets the consumer of plaintext or ciphertext input associated with this cipher operation.
     */
    abstract ConsumerInputDataFlowNode getInputConsumer();

    /**
     * Gets the consumer of a key.
     */
    abstract ConsumerInputDataFlowNode getKeyConsumer();

    /**
     * Gets the output artifact of this cipher operation.
     *
     * Implementation guidelines:
     * 1. Each unique output target should have an artifact.
     * 1. Discarded outputs from intermittent calls should not be artifacts.
     */
    abstract CipherOutputArtifactInstance getOutputArtifact();
  }

  abstract class CipherAlgorithmInstance extends AlgorithmInstance {
    /**
     * Gets the raw name as it appears in source, e.g., "AES/CBC/PKCS7Padding".
     * This name is not parsed or formatted.
     */
    abstract string getRawCipherAlgorithmName();

    /**
     * Gets the type of this cipher, e.g., "AES" or "ChaCha20".
     */
    abstract TCipherType getCipherFamily();

    /**
     * Gets the mode of operation of this cipher, e.g., "GCM" or "CBC".
     *
     * IMPLEMENTATION NOTE: as a tradeoff, this is not a consumer but always either an instance or unknown.
     * A mode of operation is therefore assumed to always be part of the cipher algorithm itself.
     */
    abstract ModeOfOperationAlgorithmInstance getModeOfOperationAlgorithm();

    /**
     * Gets the padding scheme of this cipher, e.g., "PKCS7" or "NoPadding".
     *
     * IMPLEMENTATION NOTE: as a tradeoff, this is not a consumer but always either an instance or unknown.
     * A padding algorithm is therefore assumed to always be defined as part of the cipher algorithm itself.
     */
    abstract PaddingAlgorithmInstance getPaddingAlgorithm();
  }

  abstract class ModeOfOperationAlgorithmInstance extends AlgorithmInstance {
    /**
     * Gets the type of this mode of operation, e.g., "ECB" or "CBC".
     *
     * When modeling a new mode of operation, use this predicate to specify the type of the mode.
     *
     * If a type cannot be determined, the result is `OtherMode`.
     */
    abstract TBlockCipherModeOperationType getModeType();

    /**
     * Gets the isolated name as it appears in source, e.g., "CBC" in "AES/CBC/PKCS7Padding".
     *
     * This name should not be parsed or formatted beyond isolating the raw mode name if necessary.
     */
    abstract string getRawModeAlgorithmName();
  }

  abstract class PaddingAlgorithmInstance extends AlgorithmInstance {
    /**
     * Gets the isolated name as it appears in source, e.g., "PKCS7Padding" in "AES/CBC/PKCS7Padding".
     *
     * This name should not be parsed or formatted beyond isolating the raw padding name if necessary.
     */
    abstract string getRawPaddingAlgorithmName();

    /**
     * Gets the type of this padding algorithm, e.g., "PKCS7" or "OAEP".
     *
     * When modeling a new padding algorithm, use this predicate to specify the type of the padding.
     *
     * If a type cannot be determined, the result is `OtherPadding`.
     */
    abstract TPaddingType getPaddingType();
  }

  abstract class OAEPPaddingAlgorithmInstance extends PaddingAlgorithmInstance {
    OAEPPaddingAlgorithmInstance() { this.getPaddingType() = OAEP() }

    /**
     * Gets the hash algorithm used in this padding scheme.
     */
    abstract HashAlgorithmInstance getOAEPEncodingHashAlgorithm();

    /**
     * Gets the hash algorithm used by MGF1 (assumption: MGF1 is the only MGF used by OAEP)
     */
    abstract HashAlgorithmInstance getMGF1HashAlgorithm();
  }

  newtype TMACType =
    THMAC() or
    TOtherMACType()

  abstract class MACAlgorithmInstance extends AlgorithmInstance {
    /**
     * Gets the type of this MAC algorithm, e.g., "HMAC" or "CMAC".
     */
    abstract TMACType getMACType();

    /**
     * Gets the isolated name as it appears in source, e.g., "HMAC-SHA256" in "HMAC-SHA256/UnrelatedInformation".
     *
     * This name should not be parsed or formatted beyond isolating the raw MAC name if necessary.
     */
    abstract string getRawMACAlgorithmName();
  }

  abstract class MACOperationInstance extends OperationInstance {
    /**
     * Gets the message input used in this operation.
     */
    abstract ConsumerInputDataFlowNode getMessageConsumer();

    /**
     * Gets the key used in this operation.
     */
    abstract ConsumerInputDataFlowNode getKeyConsumer();
  }

  abstract class HMACAlgorithmInstance extends MACAlgorithmInstance {
    HMACAlgorithmInstance() { this.getMACType() instanceof THMAC }

    /**
     * Gets the hash algorithm used by this HMAC algorithm.
     */
    abstract AlgorithmValueConsumer getHashAlgorithmValueConsumer();
  }

  abstract class KeyEncapsulationOperationInstance extends OperationInstance { }

  abstract class KeyEncapsulationAlgorithmInstance extends AlgorithmInstance { }

  abstract class EllipticCurveAlgorithmInstance extends AlgorithmInstance {
    /**
     * Gets the isolated name as it appears in source
     *
     * This name should not be parsed or formatted beyond isolating the raw name if necessary.
     */
    abstract string getRawEllipticCurveAlgorithmName();

    /**
     * The 'standard' curve name, e.g., "P-256" or "secp256r1".
     * meaning the full name of the curve, including the family, key size, and other
     * typical parameters found on the name. In many cases this will
     * be equivalent to `getRawEllipticCurveAlgorithmName()`, but not always
     * (e.g., if the curve is specified through a raw NID).
     * In cases like an NID, we want the standardized name so users can quickly
     * understand what the curve is, while also parsing out the family and key size
     * separately.
     */
    abstract string getStandardCurveName();

    abstract TEllipticCurveType getEllipticCurveFamily();

    abstract string getKeySize();
  }

  abstract class HashOperationInstance extends OperationInstance {
    abstract DigestArtifactInstance getDigestArtifact();
  }

  abstract class HashAlgorithmInstance extends AlgorithmInstance {
    /**
     * Gets the type of this digest algorithm, e.g., "SHA1", "SHA2", "MD5" etc.
     */
    abstract THashType getHashFamily();

    /**
     * Gets the isolated name as it appears in source, e.g., "SHA-256" in "SHA-256/PKCS7Padding".
     */
    abstract string getRawHashAlgorithmName();

    /**
     * Gets the length of the hash digest in bits.
     */
    abstract int getDigestLength();
  }

  abstract private class KeyCreationOperationInstance extends OperationInstance {
    abstract string getKeyCreationTypeDescription();

    /**
     * Gets the key artifact produced by this operation.
     */
    abstract ArtifactOutputDataFlowNode getOutputKeyArtifact();

    /**
     * Gets the key artifact type produced.
     */
    abstract KeyArtifactType getOutputKeyType();

    // Defaults or fixed values
    abstract string getKeySizeFixed();

    // Consumer input nodes
    abstract ConsumerInputDataFlowNode getKeySizeConsumer();

    final KeyArtifactOutputInstance getKeyArtifactOutputInstance() {
      result.getOutputNode() = this.getOutputKeyArtifact()
    }
  }

  abstract class KeyDerivationOperationInstance extends KeyCreationOperationInstance {
    final override KeyArtifactType getOutputKeyType() { result instanceof TSymmetricKeyType }

    final override string getKeyCreationTypeDescription() { result = "KeyDerivation" }

    // Defaults or fixed values
    abstract string getIterationCountFixed();

    abstract string getOutputKeySizeFixed();

    // Generic consumer input nodes
    abstract ConsumerInputDataFlowNode getIterationCountConsumer();

    abstract ConsumerInputDataFlowNode getOutputKeySizeConsumer();

    // Artifact consumer input nodes
    abstract ConsumerInputDataFlowNode getInputConsumer();

    abstract ConsumerInputDataFlowNode getSaltConsumer();
  }

  newtype TKeyDerivationType =
    PBKDF2() or
    PBES() or
    HKDF() or
    ARGON2() or
    OtherKeyDerivationType()

  abstract class KeyDerivationAlgorithmInstance extends AlgorithmInstance {
    /**
     * Gets the type of this key derivation algorithm, e.g., "PBKDF2" or "HKDF".
     */
    abstract TKeyDerivationType getKDFType();

    /**
     * Gets the isolated name as it appears in source, e.g., "PBKDF2WithHmacSHA256" in "PBKDF2WithHmacSHA256/UnrelatedInformation".
     */
    abstract string getRawKDFAlgorithmName();
  }

  abstract class PBKDF2AlgorithmInstance extends KeyDerivationAlgorithmInstance {
    PBKDF2AlgorithmInstance() { this.getKDFType() instanceof PBKDF2 }

    /**
     * Gets the HMAC algorithm used by this PBKDF2 algorithm.
     *
     * Note: Other PRFs are not supported, as most cryptographic libraries
     * only support HMAC for PBKDF2's PRF input.
     */
    abstract AlgorithmValueConsumer getHMACAlgorithmValueConsumer();
  }

  abstract class KeyGenerationOperationInstance extends KeyCreationOperationInstance {
    final override string getKeyCreationTypeDescription() { result = "KeyGeneration" }
  }

  abstract class KeyLoadOperationInstance extends KeyCreationOperationInstance {
    final override string getKeyCreationTypeDescription() { result = "KeyLoad" }
  }

  private signature class AlgorithmInstanceType instanceof AlgorithmInstance;

  private signature predicate isCandidateAVCSig(AlgorithmValueConsumer avc);

  module AlgorithmInstanceOrValueConsumer<
    AlgorithmInstanceType Alg, isCandidateAVCSig/1 isCandidateAVC>
  {
    class Union extends LocatableElement {
      Union() {
        // Either an AlgorithmInstance
        this instanceof Alg
        or
        // Or an AlgorithmValueConsumer with unknown sources and no known sources
        isCandidateAVC(this) and
        not exists(this.(AlgorithmValueConsumer).getAKnownAlgorithmSource()) and
        exists(this.(AlgorithmValueConsumer).getAGenericSource())
      }

      Alg asAlg() { result = this }

      AlgorithmValueConsumer asAVC() { result = this }
    }
  }

  private predicate isHashAVC(AlgorithmValueConsumer avc) {
    exists(HashOperationInstance op | op.getAnAlgorithmValueConsumer() = avc) or
    exists(HMACAlgorithmInstance alg | avc = alg.getAConsumer())
  }

  private predicate isCipherAVC(AlgorithmValueConsumer avc) {
    exists(CipherOperationInstance op | op.getAnAlgorithmValueConsumer() = avc)
  }

  private predicate isMACAVC(AlgorithmValueConsumer avc) {
    exists(MACOperationInstance op | op.getAnAlgorithmValueConsumer() = avc) or
    exists(PBKDF2AlgorithmInstance alg | avc = alg.getHMACAlgorithmValueConsumer())
  }

  private predicate isKeyDerivationAVC(AlgorithmValueConsumer avc) {
    exists(KeyDerivationOperationInstance op | op.getAnAlgorithmValueConsumer() = avc)
  }

  final private class CipherAlgorithmInstanceOrValueConsumer =
    AlgorithmInstanceOrValueConsumer<CipherAlgorithmInstance, isCipherAVC/1>::Union;

  final private class HashAlgorithmInstanceOrValueConsumer =
    AlgorithmInstanceOrValueConsumer<HashAlgorithmInstance, isHashAVC/1>::Union;

  final private class MACAlgorithmInstanceOrValueConsumer =
    AlgorithmInstanceOrValueConsumer<MACAlgorithmInstance, isMACAVC/1>::Union;

  final private class KeyDerivationAlgorithmInstanceOrValueConsumer =
    AlgorithmInstanceOrValueConsumer<KeyDerivationAlgorithmInstance, isKeyDerivationAVC/1>::Union;

  final private class EllipticCurveAlgorithmInstanceOrValueConsumer =
    AlgorithmInstanceOrValueConsumer<EllipticCurveAlgorithmInstance, isKeyDerivationAVC/1>::Union;

  private newtype TNode =
    // Artifacts (data that is not an operation or algorithm, e.g., a key)
    TDigest(DigestArtifactInstance e) or
    TKey(KeyArtifactInstance e) or
    TCipherOutput(CipherOutputArtifactInstance e) or
    // Input artifact nodes (synthetic, used to differentiate input as entities)
    TNonceInput(NonceArtifactConsumer e) or
    TMessageInput(MessageArtifactConsumer e) or
    TSaltInput(SaltArtifactConsumer e) or
    TRandomNumberGeneration(RandomNumberGenerationInstance e) { e.flowsTo(_) } or
    // Operations (e.g., hashing, encryption)
    THashOperation(HashOperationInstance e) or
    TCipherOperation(CipherOperationInstance e) or
    TKeyEncapsulationOperation(KeyEncapsulationOperationInstance e) or
    TMACOperation(MACOperationInstance e) or
    // Key Creation Operations
    TKeyCreationOperation(KeyCreationOperationInstance e) or
    // Algorithms (e.g., SHA-256, AES)
    TCipherAlgorithm(CipherAlgorithmInstanceOrValueConsumer e) or
    TEllipticCurveAlgorithm(EllipticCurveAlgorithmInstanceOrValueConsumer e) or
    THashAlgorithm(HashAlgorithmInstanceOrValueConsumer e) or
    TKeyDerivationAlgorithm(KeyDerivationAlgorithmInstanceOrValueConsumer e) or
    TKeyEncapsulationAlgorithm(KeyEncapsulationAlgorithmInstance e) or
    TMACAlgorithm(MACAlgorithmInstanceOrValueConsumer e) or
    // Non-standalone Algorithms (e.g., Mode, Padding)
    // TODO: need to rename this, as "mode" is getting reused in different contexts, be precise
    TModeOfOperationAlgorithm(ModeOfOperationAlgorithmInstance e) or
    TPaddingAlgorithm(PaddingAlgorithmInstance e) or
    // Composite and hybrid cryptosystems (e.g., RSA-OAEP used with AES, post-quantum hybrid cryptosystems)
    // These nodes are always parent nodes and are not modeled but rather defined via library-agnostic patterns.
    TKemDemHybridCryptosystem(CipherAlgorithmNode dem) or // TODO, change this relation and the below ones
    TKeyAgreementHybridCryptosystem(CipherAlgorithmInstance ka) or
    TAsymmetricEncryptionMacHybridCryptosystem(CipherAlgorithmInstance enc) or
    TPostQuantumHybridCryptosystem(CipherAlgorithmInstance enc) or
    // Generic source nodes
    TGenericSourceNode(GenericSourceInstance e) {
      // An element modelled as a `GenericSourceInstance` can also be modelled as a `KnownElement`
      // For example, a string literal "AES" could be a generic constant but also an algorithm instance.
      // Only create generic nodes tied to instances which are not also a `KnownElement`.
      not e instanceof KnownElement and
      // Only create nodes for generic sources which flow to other elements
      e.flowsTo(_)
    }

  /**
   * The base class for all cryptographic assets, such as operations and algorithms.
   *
   * Each `NodeBase` is a node in a graph of cryptographic operations, where the edges are the relationships between the nodes.
   *
   * A node, as opposed to a property, is a construct that can reference or be referenced by more than one node.
   * For example: a key size is a single value configuring a cipher algorithm, but a single mode of operation algorithm
   * can be referenced by multiple disjoint cipher algorithms. For example, even if the same key size value is reused
   * for multiple cipher algorithms, the key size holds no information when devolved to that simple value, and it is
   * therefore not a "construct" or "element" being reused by multiple nodes.
   *
   * As a rule of thumb, a node is an algorithm or the use of an algorithm (an operation), as well as structured data
   * consumed by or produced by an operation or algorithm (an artifact) that represents a construct beyond its data.
   *
   * _Example 1_: A seed of a random number generation algorithm has meaning beyond its value, as its reuse in multiple
   * random number generation algorithms is more relevant than its underlying value. In contrast, a key size is only
   * relevant to analysis in terms of its underlying value. Therefore, an RNG seed is a node; a key size is not. However,
   * the key size might have a `GenericSourceNode` source, even if it itself is not a node.
   *
   * _Example 2_: A salt for a key derivation function *is* an `ArtifactNode`.
   *
   * _Example 3_: The iteration count of a key derivation function is *not* a node, but it may link to a generic node.
   *
   * _Example 4_: A nonce for a cipher operation *is* an `ArtifactNode`.
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
    Location getLocation() { result = this.asElement().getLocation() }

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
    predicate properties(string key, string value, Location location) { none() }

    /**
     * Returns a parent of this node.
     */
    final NodeBase getAParent() { result.getChild(_) = this }

    /**
     * Gets the element associated with this node.
     */
    abstract LocatableElement asElement();

    /**
     * If this predicate holds, this node should be excluded from the graph.
     */
    predicate isExcludedFromGraph() { none() }
  }

  /**
   * A generic source node is a source of data that is not resolvable to a specific asset.
   */
  private class GenericSourceNode extends NodeBase, TGenericSourceNode {
    GenericSourceInstance instance;

    GenericSourceNode() { this = TGenericSourceNode(instance) }

    final override string getInternalType() { result = instance.getInternalType() }

    override LocatableElement asElement() { result = instance }

    override predicate properties(string key, string value, Location location) {
      super.properties(key, value, location)
      or
      // [ONLY_KNOWN]
      key = "Description" and
      value = instance.getAdditionalDescription() and
      location = this.getLocation()
    }

    override predicate isExcludedFromGraph() {
      // Exclude generic source instances that are not child nodes of another node
      not exists(NodeBase other | other != this and other.getChild(_) = this)
    }
  }

  class AssetNode = NodeBase;

  /**
   * A cryptographic operation, such as hashing or encryption.
   */
  abstract class OperationNode extends AssetNode {
    /**
     * Holds if `node` is a potential candidate for a known algorithm node.
     * This predicate should be used to restrict the set of candidate algorithm node types.
     */
    abstract predicate isCandidateAlgorithmNode(AlgorithmNode node);

    /**
     * Gets the algorithm or generic source nodes consumed as an algorithm associated with this operation.
     */
    NodeBase getAnAlgorithmOrGenericSource() {
      result = this.getAKnownAlgorithm() or
      result =
        this.asElement().(OperationInstance).getAnAlgorithmValueConsumer().getAGenericSourceNode()
    }

    /**
     * Gets a known algorithm associated with this operation, subject to `isCandidateAlgorithmNode`.
     */
    AlgorithmNode getAKnownAlgorithm() {
      result =
        this.asElement().(OperationInstance).getAnAlgorithmValueConsumer().getAKnownSourceNode() and
      this.isCandidateAlgorithmNode(result)
    }

    override NodeBase getChild(string edgeName) {
      result = super.getChild(edgeName)
      or
      // [KNOWN_OR_UNKNOWN]
      edgeName = "Algorithm" and
      if exists(this.getAnAlgorithmOrGenericSource())
      then result = this.getAnAlgorithmOrGenericSource()
      else result = this
    }
  }

  abstract class AlgorithmNode extends AssetNode {
    /**
     * Gets the name of this algorithm, e.g., "AES" or "SHA".
     */
    abstract string getAlgorithmName();

    /**
     * Gets the raw name of this algorithm from source (no parsing or formatting)
     */
    abstract string getRawAlgorithmName();

    override predicate properties(string key, string value, Location location) {
      super.properties(key, value, location)
      or
      // [ONLY_KNOWN]
      key = "Name" and value = this.getAlgorithmName() and location = this.getLocation()
      or
      // [ONLY_KNOWN]
      key = "RawName" and value = this.getRawAlgorithmName() and location = this.getLocation()
    }
  }

  /**
   * An artifact is an instance of data that is used in a cryptographic operation or produced by one.
   */
  abstract class ArtifactNode extends NodeBase {
    /**
     * Gets the `ArtifactNode` or `GenericSourceNode` node that is the data source for this artifact.
     */
    final NodeBase getSourceNode() {
      result.asElement() = this.getSourceElement() and
      (result instanceof ArtifactNode or result instanceof GenericSourceNode)
    }

    /**
     * Gets the `ArtifactLocatableElement` that is the data source for this artifact.
     *
     * This predicate is equivalent to `getSourceArtifact().asArtifactLocatableElement()`.
     */
    final FlowAwareElement getSourceElement() {
      not result = this.asElement() and result.flowsTo(this.asElement())
    }

    /**
     * Gets a string describing the relationship between this artifact and its source.
     *
     * If a child class defines this predicate as `none()`, no relationship will be reported.
     */
    string getSourceNodeRelationship() { result = "Source" } // TODO: revisit why this exists

    override NodeBase getChild(string edgeName) {
      result = super.getChild(edgeName)
      or
      // [KNOWN_OR_UNKNOWN]
      edgeName = this.getSourceNodeRelationship() and // TODO: only holds if not set to none().. revisit this
      if exists(this.getSourceNode()) then result = this.getSourceNode() else result = this
    }
  }

  /**
   * A nonce or initialization vector input
   */
  final class NonceArtifactNode extends ArtifactNode, TNonceInput {
    NonceArtifactConsumer instance;

    NonceArtifactNode() { this = TNonceInput(instance) }

    final override string getInternalType() { result = "Nonce" }

    override LocatableElement asElement() { result = instance }
  }

  /**
   * A message or plaintext/ciphertext input
   */
  final class MessageArtifactNode extends ArtifactNode, TMessageInput {
    MessageArtifactConsumer instance;

    MessageArtifactNode() { this = TMessageInput(instance) }

    final override string getInternalType() { result = "Message" }

    override LocatableElement asElement() { result = instance }
  }

  /**
   * A salt input
   */
  final class SaltArtifactNode extends ArtifactNode, TSaltInput {
    SaltArtifactConsumer instance;

    SaltArtifactNode() { this = TSaltInput(instance) }

    final override string getInternalType() { result = "Salt" }

    override LocatableElement asElement() { result = instance }
  }

  /**
   * Output text from a cipher operation
   */
  final class CipherOutputNode extends ArtifactNode, TCipherOutput {
    CipherOutputArtifactInstance instance;

    CipherOutputNode() { this = TCipherOutput(instance) }

    final override string getInternalType() { result = "CipherOutput" }

    override LocatableElement asElement() { result = instance }

    override string getSourceNodeRelationship() { none() }
  }

  /**
   * A source of random number generation
   */
  final class RandomNumberGenerationNode extends ArtifactNode, TRandomNumberGeneration {
    RandomNumberGenerationInstance instance;

    RandomNumberGenerationNode() { this = TRandomNumberGeneration(instance) }

    final override string getInternalType() { result = "RandomNumberGeneration" }

    override LocatableElement asElement() { result = instance }

    override string getSourceNodeRelationship() { none() } // TODO: seed?
  }

  /**
   * A cryptographic key, such as a symmetric key or asymmetric key pair.
   */
  final class KeyArtifactNode extends ArtifactNode, TKey {
    KeyArtifactInstance instance;

    KeyArtifactNode() { this = TKey(instance) }

    final override string getInternalType() { result = "Key" }

    override LocatableElement asElement() { result = instance }

    NodeBase getAKnownAlgorithmOrGenericSourceNode() {
      result = this.getAKnownAlgorithm() or
      result =
        instance
            .(KeyCreationOperationInstance)
            .getAnAlgorithmValueConsumer()
            .getAGenericSourceNode()
    }

    CipherAlgorithmNode getAKnownAlgorithm() {
      result =
        instance.(KeyCreationOperationInstance).getAnAlgorithmValueConsumer().getAKnownSourceNode()
    }

    override NodeBase getChild(string edgeName) {
      result = super.getChild(edgeName)
      or
      // [KNOWN_OR_UNKNOWN] - only if asymmetric
      edgeName = "Algorithm" and
      instance.getKeyType() instanceof TAsymmetricKeyType and
      (
        if exists(this.getAKnownAlgorithmOrGenericSourceNode())
        then result = this.getAKnownAlgorithmOrGenericSourceNode()
        else result = this
      )
    }

    override predicate properties(string key, string value, Location location) {
      super.properties(key, value, location)
      or
      // [ONLY_KNOWN]
      key = "KeyType" and
      value = instance.getKeyType().toString() and
      location = this.getLocation()
    }

    override string getSourceNodeRelationship() {
      instance.isConsumerArtifact() and
      result = "Source"
    }
  }

  /**
   * A digest produced by a hash operation.
   */
  final class DigestArtifactNode extends ArtifactNode, TDigest {
    DigestArtifactInstance instance;

    DigestArtifactNode() { this = TDigest(instance) }

    final override string getInternalType() { result = "Digest" }

    override LocatableElement asElement() { result = instance }
  }

  abstract class KeyCreationOperationNode extends OperationNode, TKeyCreationOperation {
    KeyCreationOperationInstance instance;

    KeyCreationOperationNode() { this = TKeyCreationOperation(instance) }

    override LocatableElement asElement() { result = instance }

    override string getInternalType() { result = instance.getKeyCreationTypeDescription() }

    /**
     * Gets the key artifact produced by this operation.
     */
    KeyArtifactNode getOutputKeyArtifact() {
      instance.getKeyArtifactOutputInstance() = result.asElement()
    }

    override NodeBase getChild(string key) {
      result = super.getChild(key)
      or
      // [ALWAYS_KNOWN]
      key = "Output" and
      result = this.getOutputKeyArtifact()
    }
  }

  /**
   * A MAC operation that produces a MAC value.
   */
  final class MACOperationNode extends OperationNode, TMACOperation {
    MACOperationInstance instance;

    MACOperationNode() { this = TMACOperation(instance) }

    final override string getInternalType() { result = "MACOperation" }

    override LocatableElement asElement() { result = instance }

    override predicate isCandidateAlgorithmNode(AlgorithmNode node) {
      node instanceof MACAlgorithmNode
    }

    MessageArtifactNode getAMessage() {
      result.asElement() = instance.getMessageConsumer().getConsumer()
    }

    KeyArtifactNode getAKey() { result.asElement() = instance.getKeyConsumer().getConsumer() }

    override NodeBase getChild(string edgeName) {
      result = super.getChild(edgeName)
      or
      // [KNOWN_OR_UNKNOWN]
      edgeName = "Message" and
      if exists(this.getAMessage()) then result = this.getAMessage() else result = this
      or
      // [KNOWN_OR_UNKNOWN]
      edgeName = "Key" and
      if exists(this.getAKey()) then result = this.getAKey() else result = this
    }
  }

  /**
   * A MAC algorithm, such as HMAC or CMAC.
   */
  class MACAlgorithmNode extends AlgorithmNode, TMACAlgorithm {
    MACAlgorithmInstanceOrValueConsumer instance;

    MACAlgorithmNode() { this = TMACAlgorithm(instance) }

    final override string getInternalType() { result = "MACAlgorithm" }

    override LocatableElement asElement() { result = instance }

    final override string getRawAlgorithmName() {
      result = instance.asAlg().getRawMACAlgorithmName()
    }

    TMACType getMACType() { result = instance.asAlg().getMACType() }

    bindingset[type]
    final private predicate macToNameMapping(TMACType type, string name) {
      type instanceof THMAC and
      name = "HMAC"
    }

    override string getAlgorithmName() { this.macToNameMapping(this.getMACType(), result) }
  }

  final class HMACAlgorithmNode extends MACAlgorithmNode {
    HMACAlgorithmInstance hmacInstance;

    HMACAlgorithmNode() { hmacInstance = instance.asAlg() }

    NodeBase getHashAlgorithmOrUnknown() {
      result.asElement() = hmacInstance.getHashAlgorithmValueConsumer().getASource()
    }

    override NodeBase getChild(string edgeName) {
      result = super.getChild(edgeName)
      or
      // [KNOWN_OR_UNKNOWN]
      edgeName = "H" and
      if exists(this.getHashAlgorithmOrUnknown())
      then result = this.getHashAlgorithmOrUnknown()
      else result = this
    }
  }

  class KeyGenerationOperationNode extends KeyCreationOperationNode {
    KeyGenerationOperationInstance keyGenInstance;

    KeyGenerationOperationNode() { keyGenInstance = instance }

    override predicate isCandidateAlgorithmNode(AlgorithmNode node) {
      node instanceof CipherAlgorithmNode
    }

    override NodeBase getChild(string key) {
      result = super.getChild(key)
      or
      // [ALWAYS_KNOWN]
      key = "Output" and
      result = this.getOutputKeyArtifact()
    }
  }

  class KeyDerivationOperationNode extends KeyCreationOperationNode {
    KeyDerivationOperationInstance kdfInstance;

    KeyDerivationOperationNode() { kdfInstance = instance }

    MessageArtifactNode getInput() {
      result.asElement() = kdfInstance.getInputConsumer().getConsumer()
    }

    SaltArtifactNode getSalt() {
      result.asElement().(SaltArtifactConsumer).getInputNode() = kdfInstance.getSaltConsumer()
    }

    GenericSourceNode getIterationCount() {
      result.asElement() = kdfInstance.getIterationCountConsumer().getConsumer().getAGenericSource()
    }

    GenericSourceNode getOutputKeySize() {
      result.asElement() = kdfInstance.getOutputKeySizeConsumer().getConsumer().getAGenericSource()
    }

    override predicate isCandidateAlgorithmNode(AlgorithmNode node) {
      node instanceof KeyDerivationAlgorithmNode
    }

    override NodeBase getChild(string key) {
      result = super.getChild(key)
      or
      // [KNOWN_OR_UNKNOWN]
      key = "Input" and
      if exists(this.getInput()) then result = this.getInput() else result = this
      or
      // [KNOWN_OR_UNKNOWN]
      key = "Salt" and
      if exists(this.getSalt()) then result = this.getSalt() else result = this
    }

    override predicate properties(string key, string value, Location location) {
      super.properties(key, value, location)
      or
      // [ONLY_KNOWN]
      key = "DefaultIterations" and
      value = kdfInstance.getIterationCountFixed() and
      location = this.getLocation()
      or
      // [ONLY_KNOWN]
      key = "DefaultKeySize" and
      value = kdfInstance.getKeySizeFixed() and
      location = this.getLocation()
      or
      // [ONLY_KNOWN] - TODO: refactor for known unknowns
      key = "Iterations" and
      node_as_property(this.getIterationCount(), value, location)
      or
      // [ONLY_KNOWN] - TODO: refactor for known unknowns
      key = "KeySize" and
      node_as_property(this.getOutputKeySize(), value, location)
    }
  }

  class KeyDerivationAlgorithmNode extends AlgorithmNode, TKeyDerivationAlgorithm {
    KeyDerivationAlgorithmInstanceOrValueConsumer instance;

    KeyDerivationAlgorithmNode() { this = TKeyDerivationAlgorithm(instance) }

    final override string getInternalType() { result = "KeyDerivationAlgorithm" }

    override LocatableElement asElement() { result = instance }

    final override string getRawAlgorithmName() {
      result = instance.asAlg().getRawKDFAlgorithmName()
    }

    final override string getAlgorithmName() { result = this.getRawAlgorithmName() }
  }

  /**
   * PBKDF2 key derivation function
   */
  class PBKDF2AlgorithmNode extends KeyDerivationAlgorithmNode {
    PBKDF2AlgorithmInstance pbkdf2Instance;

    PBKDF2AlgorithmNode() { pbkdf2Instance = instance.asAlg() }

    HMACAlgorithmNode getHMACAlgorithm() {
      result.asElement() = pbkdf2Instance.getHMACAlgorithmValueConsumer().getASource()
    }

    override NodeBase getChild(string key) {
      result = super.getChild(key)
      or
      // [KNOWN_OR_UNKNOWN]
      key = "PRF" and
      if exists(this.getHMACAlgorithm()) then result = this.getHMACAlgorithm() else result = this
    }
  }

  // /**
  //  * PKCS12KDF key derivation function
  //  */
  // abstract class PKCS12KDF extends KeyDerivationWithDigestParameterNode {
  //   override string getAlgorithmName() { result = "PKCS12KDF" }
  //   /**
  //    * Gets the iteration count of this key derivation algorithm.
  //    */
  //   abstract string getIterationCount(Location location);
  //   /**
  //    * Gets the raw ID argument specifying the intended use of the derived key.
  //    *
  //    * The intended use is defined in RFC 7292, appendix B.3, as follows:
  //    *
  //    * This standard specifies 3 different values for the ID byte mentioned above:
  //    *
  //    *   1.  If ID=1, then the pseudorandom bits being produced are to be used
  //    *       as key material for performing encryption or decryption.
  //    *
  //    *   2.  If ID=2, then the pseudorandom bits being produced are to be used
  //    *       as an IV (Initial Value) for encryption or decryption.
  //    *
  //    *   3.  If ID=3, then the pseudorandom bits being produced are to be used
  //    *       as an integrity key for MACing.
  //    */
  //   abstract string getIDByte(Location location);
  //   override predicate properties(string key, string value, Location location) {
  //     super.properties(key, value, location)
  //     or
  //     (
  //       // [KNOWN_OR_UNKNOWN]
  //       key = "Iterations" and
  //       if exists(this.getIterationCount(location))
  //       then value = this.getIterationCount(location)
  //       else (
  //         value instanceof UnknownPropertyValue and location instanceof UnknownLocation
  //       )
  //     )
  //     or
  //     (
  //       // [KNOWN_OR_UNKNOWN]
  //       key = "IdByte" and
  //       if exists(this.getIDByte(location))
  //       then value = this.getIDByte(location)
  //       else (
  //         value instanceof UnknownPropertyValue and location instanceof UnknownLocation
  //       )
  //     )
  //   }
  // }
  // /**
  //  * scrypt key derivation function
  //  */
  // abstract class SCRYPT extends KeyDerivationAlgorithmNode {
  //   final override string getAlgorithmName() { result = "scrypt" }
  //   /**
  //    * Gets the iteration count (`N`) argument
  //    */
  //   abstract string get_N(Location location);
  //   /**
  //    * Gets the block size (`r`) argument
  //    */
  //   abstract string get_r(Location location);
  //   /**
  //    * Gets the parallelization factor (`p`) argument
  //    */
  //   abstract string get_p(Location location);
  //   /**
  //    * Gets the derived key length argument
  //    */
  //   abstract string getDerivedKeyLength(Location location);
  //   override predicate properties(string key, string value, Location location) {
  //     super.properties(key, value, location)
  //     or
  //     (
  //       // [KNOWN_OR_UNKNOWN]
  //       key = "N" and
  //       if exists(this.get_N(location))
  //       then value = this.get_N(location)
  //       else (
  //         value instanceof UnknownPropertyValue and location instanceof UnknownLocation
  //       )
  //     )
  //     or
  //     (
  //       // [KNOWN_OR_UNKNOWN]
  //       key = "r" and
  //       if exists(this.get_r(location))
  //       then value = this.get_r(location)
  //       else (
  //         value instanceof UnknownPropertyValue and location instanceof UnknownLocation
  //       )
  //     )
  //     or
  //     (
  //       // [KNOWN_OR_UNKNOWN]
  //       key = "p" and
  //       if exists(this.get_p(location))
  //       then value = this.get_p(location)
  //       else (
  //         value instanceof UnknownPropertyValue and location instanceof UnknownLocation
  //       )
  //     )
  //     or
  //     (
  //       // [KNOWN_OR_UNKNOWN]
  //       key = "KeyLength" and
  //       if exists(this.getDerivedKeyLength(location))
  //       then value = this.getDerivedKeyLength(location)
  //       else (
  //         value instanceof UnknownPropertyValue and location instanceof UnknownLocation
  //       )
  //     )
  //   }
  // }
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

  newtype TCipherOperationSubtype =
    TEncryptionMode() or
    TDecryptionMode() or
    TWrapMode() or
    TUnwrapMode() or
    TSignatureMode() or
    TUnknownCipherOperationMode()

  abstract class CipherOperationSubtype extends TCipherOperationSubtype {
    abstract string toString();
  }

  class EncryptionSubtype extends CipherOperationSubtype, TEncryptionMode {
    override string toString() { result = "Encrypt" }
  }

  class DecryptionSubtype extends CipherOperationSubtype, TDecryptionMode {
    override string toString() { result = "Decrypt" }
  }

  class WrapSubtype extends CipherOperationSubtype, TWrapMode {
    override string toString() { result = "Wrap" }
  }

  class UnwrapSubtype extends CipherOperationSubtype, TUnwrapMode {
    override string toString() { result = "Unwrap" }
  }

  class SignatureSubtype extends CipherOperationSubtype, TSignatureMode {
    override string toString() { result = "Sign" }
  }

  class UnknownCipherOperationSubtype extends CipherOperationSubtype, TUnknownCipherOperationMode {
    override string toString() { result = "Unknown" }
  }

  /**
   * An encryption operation that processes plaintext to generate a ciphertext.
   * This operation takes an input message (plaintext) of arbitrary content and length
   * and produces a ciphertext as the output using a specified encryption algorithm (with a mode and padding).
   */
  final class CipherOperationNode extends OperationNode, TCipherOperation {
    CipherOperationInstance instance;

    CipherOperationNode() { this = TCipherOperation(instance) }

    override LocatableElement asElement() { result = instance }

    override string getInternalType() { result = "CipherOperation" }

    override predicate isCandidateAlgorithmNode(AlgorithmNode node) {
      node instanceof CipherAlgorithmNode
    }

    CipherOperationSubtype getCipherOperationSubtype() {
      result = instance.getCipherOperationSubtype()
    }

    NonceArtifactNode getANonce() { result.asElement() = instance.getNonceConsumer().getConsumer() }

    MessageArtifactNode getAnInputArtifact() {
      result.asElement() = instance.getInputConsumer().getConsumer()
    }

    CipherOutputNode getAnOutputArtifact() { result.asElement() = instance.getOutputArtifact() }

    KeyArtifactNode getAKey() { result.asElement() = instance.getKeyConsumer().getConsumer() }

    override NodeBase getChild(string key) {
      result = super.getChild(key)
      or
      // [KNOWN_OR_UNKNOWN]
      key = "Nonce" and
      if exists(this.getANonce()) then result = this.getANonce() else result = this
      or
      // [KNOWN_OR_UNKNOWN]
      key = "InputText" and
      if exists(this.getAnInputArtifact())
      then result = this.getAnInputArtifact()
      else result = this
      or
      // [KNOWN_OR_UNKNOWN]
      key = "OutputText" and
      if exists(this.getAnOutputArtifact())
      then result = this.getAnOutputArtifact()
      else result = this
      or
      // [KNOWN_OR_UNKNOWN]
      key = "Key" and
      if exists(this.getAKey()) then result = this.getAKey() else result = this
    }

    override predicate properties(string key, string value, Location location) {
      super.properties(key, value, location)
      or
      // [ALWAYS_KNOWN] - Unknown is handled in getCipherOperationMode()
      key = "Operation" and
      value = this.getCipherOperationSubtype().toString() and
      location = this.getLocation()
    }
  }

  /**
   * Block cipher modes of operation algorithms
   */
  newtype TBlockCipherModeOperationType =
    ECB() or // Not secure, widely used
    CBC() or // Vulnerable to padding oracle attacks
    CFB() or
    GCM() or // Widely used AEAD mode (TLS 1.3, SSH, IPsec)
    CTR() or // Fast stream-like encryption (SSH, disk encryption)
    XTS() or // Standard for full-disk encryption (BitLocker, LUKS, FileVault)
    CCM() or // Used in lightweight cryptography (IoT, WPA2)
    SIV() or // Misuse-resistant encryption, used in secure storage
    OCB() or // Efficient AEAD mode
    OFB() or
    OtherMode()

  class ModeOfOperationAlgorithmNode extends AlgorithmNode, TModeOfOperationAlgorithm {
    ModeOfOperationAlgorithmInstance instance;

    ModeOfOperationAlgorithmNode() { this = TModeOfOperationAlgorithm(instance) }

    override LocatableElement asElement() { result = instance }

    override string getInternalType() { result = "ModeOfOperation" }

    override string getRawAlgorithmName() { result = instance.getRawModeAlgorithmName() }

    /**
     * Gets the type of this mode of operation, e.g., "ECB" or "CBC".
     *
     * When modeling a new mode of operation, use this predicate to specify the type of the mode.
     *
     * If a type cannot be determined, the result is `OtherMode`.
     */
    TBlockCipherModeOperationType getModeType() { result = instance.getModeType() }

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
      type instanceof CFB and name = "CFB"
      or
      type instanceof OFB and name = "OFB"
    }

    override string getAlgorithmName() { this.modeToNameMapping(this.getModeType(), result) }
  }

  newtype TPaddingType =
    PKCS1_v1_5() or // RSA encryption/signing padding
    PSS() or
    PKCS7() or // Standard block cipher padding (PKCS5 for 8-byte blocks)
    ANSI_X9_23() or // Zero-padding except last byte = padding length
    NoPadding() or // Explicit no-padding
    OAEP() or // RSA OAEP padding
    OtherPadding()

  class PaddingAlgorithmNode extends AlgorithmNode, TPaddingAlgorithm {
    PaddingAlgorithmInstance instance;

    PaddingAlgorithmNode() { this = TPaddingAlgorithm(instance) }

    override string getInternalType() { result = "PaddingAlgorithm" }

    override LocatableElement asElement() { result = instance }

    TPaddingType getPaddingType() { result = instance.getPaddingType() }

    bindingset[type]
    final private predicate paddingToNameMapping(TPaddingType type, string name) {
      type instanceof PKCS1_v1_5 and name = "PKCS1_v1_5"
      or
      type instanceof PSS and name = "PSS"
      or
      type instanceof PKCS7 and name = "PKCS7"
      or
      type instanceof ANSI_X9_23 and name = "ANSI_X9_23"
      or
      type instanceof NoPadding and name = "NoPadding"
      or
      type instanceof OAEP and name = "OAEP"
    }

    override string getAlgorithmName() { this.paddingToNameMapping(this.getPaddingType(), result) }

    override string getRawAlgorithmName() { result = instance.getRawPaddingAlgorithmName() }
  }

  class OAEPPaddingAlgorithmNode extends PaddingAlgorithmNode {
    override OAEPPaddingAlgorithmInstance instance;

    OAEPPaddingAlgorithmNode() { this = TPaddingAlgorithm(instance) }

    HashAlgorithmNode getOAEPEncodingHashAlgorithm() {
      result.asElement() = instance.getOAEPEncodingHashAlgorithm()
    }

    HashAlgorithmNode getMGF1HashAlgorithm() {
      result.asElement() = instance.getMGF1HashAlgorithm()
    }

    override NodeBase getChild(string edgeName) {
      result = super.getChild(edgeName)
      or
      // [KNOWN_OR_UNKNOWN]
      edgeName = "MD" and
      if exists(this.getOAEPEncodingHashAlgorithm())
      then result = this.getOAEPEncodingHashAlgorithm()
      else result = this
      or
      // [KNOWN_OR_UNKNOWN]
      edgeName = "MGF1Hash" and
      if exists(this.getMGF1HashAlgorithm())
      then result = this.getMGF1HashAlgorithm()
      else result = this
    }
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
    ARIA() or
    BLOWFISH() or
    CAMELLIA() or
    CAST5() or
    CHACHA20() or
    DES() or
    DESX() or
    GOST() or
    IDEA() or
    KUZNYECHIK() or
    MAGMA() or
    TripleDES() or
    DoubleDES() or
    RC2() or
    RC4() or
    RC5() or
    RSA() or
    SEED() or
    SM4() or
    OtherCipherType()

  final class CipherAlgorithmNode extends AlgorithmNode, TCipherAlgorithm {
    CipherAlgorithmInstanceOrValueConsumer instance;

    CipherAlgorithmNode() { this = TCipherAlgorithm(instance) }

    override LocatableElement asElement() { result = instance }

    override string getInternalType() { result = "CipherAlgorithm" }

    final TCipherStructureType getCipherStructure() {
      this.cipherFamilyToNameAndStructure(this.getCipherFamily(), _, result)
    }

    final override string getAlgorithmName() {
      this.cipherFamilyToNameAndStructure(this.getCipherFamily(), result, _)
    }

    final override string getRawAlgorithmName() {
      result = instance.asAlg().getRawCipherAlgorithmName()
    }

    /**
     * Gets the key size of this cipher, e.g., "128" or "256".
     */
    string getKeySize(Location location) { none() } // TODO

    /**
     * Gets the type of this cipher, e.g., "AES" or "ChaCha20".
     */
    TCipherType getCipherFamily() { result = instance.asAlg().getCipherFamily() }

    /**
     * Gets the mode of operation of this cipher, e.g., "GCM" or "CBC".
     */
    ModeOfOperationAlgorithmNode getModeOfOperation() {
      result.asElement() = instance.asAlg().getModeOfOperationAlgorithm()
    }

    /**
     * Gets the padding scheme of this cipher, e.g., "PKCS7" or "NoPadding".
     */
    PaddingAlgorithmNode getPaddingAlgorithm() {
      result.asElement() = instance.asAlg().getPaddingAlgorithm()
    }

    bindingset[type]
    final private predicate cipherFamilyToNameAndStructure(
      TCipherType type, string name, TCipherStructureType s
    ) {
      type instanceof AES and name = "AES" and s = Block()
      or
      type instanceof ARIA and name = "ARIA" and s = Block()
      or
      type instanceof BLOWFISH and name = "Blowfish" and s = Block()
      or
      type instanceof CAMELLIA and name = "Camellia" and s = Block()
      or
      type instanceof CAST5 and name = "CAST5" and s = Block()
      or
      type instanceof CHACHA20 and name = "ChaCha20" and s = Stream()
      or
      type instanceof DES and name = "DES" and s = Block()
      or
      type instanceof DESX and name = "DESX" and s = Block()
      or
      type instanceof GOST and name = "GOST" and s = Block()
      or
      type instanceof IDEA and name = "IDEA" and s = Block()
      or
      type instanceof KUZNYECHIK and name = "Kuznyechik" and s = Block()
      or
      type instanceof MAGMA and name = "Magma" and s = Block()
      or
      type instanceof TripleDES and name = "TripleDES" and s = Block()
      or
      type instanceof DoubleDES and name = "DoubleDES" and s = Block()
      or
      type instanceof RC2 and name = "RC2" and s = Block()
      or
      type instanceof RC4 and name = "RC4" and s = Stream()
      or
      type instanceof RC5 and name = "RC5" and s = Block()
      or
      type instanceof RSA and name = "RSA" and s = Asymmetric()
      or
      type instanceof SEED and name = "SEED" and s = Block()
      or
      type instanceof SM4 and name = "SM4" and s = Block()
      or
      type instanceof OtherCipherType and
      name instanceof UnknownPropertyValue and // TODO: get rid of this hack to bind structure and type
      s = UnknownCipherStructureType()
    }

    override NodeBase getChild(string edgeName) {
      result = super.getChild(edgeName)
      or
      // [KNOWN_OR_UNKNOWN]
      edgeName = "Mode" and
      if exists(this.getModeOfOperation())
      then result = this.getModeOfOperation()
      else result = this
      or
      // [KNOWN_OR_UNKNOWN]
      edgeName = "Padding" and
      if exists(this.getPaddingAlgorithm())
      then result = this.getPaddingAlgorithm()
      else result = this
    }

    override predicate properties(string key, string value, Location location) {
      super.properties(key, value, location)
      or
      // [ALWAYS_KNOWN] - unknown case is handled in `getCipherStructureTypeString`
      key = "Structure" and
      getCipherStructureTypeString(this.getCipherStructure()) = value and
      location instanceof UnknownLocation
      or
      (
        // [KNOWN_OR_UNKNOWN]
        key = "KeySize" and
        if exists(this.getKeySize(location))
        then value = this.getKeySize(location)
        else (
          value instanceof UnknownPropertyValue and location instanceof UnknownLocation
        )
      )
    }
  }

  /**
   * A hashing operation that processes data to generate a hash value.
   *
   * This operation takes an input message of arbitrary content and length and produces a fixed-size
   * hash value as the output using a specified hashing algorithm.
   */
  class HashOperationNode extends OperationNode, THashOperation {
    HashOperationInstance instance;

    HashOperationNode() { this = THashOperation(instance) }

    override string getInternalType() { result = "HashOperation" }

    override LocatableElement asElement() { result = instance }

    override predicate isCandidateAlgorithmNode(AlgorithmNode node) {
      node instanceof HashAlgorithmNode
    }

    /**
     * Gets the output digest node
     */
    DigestArtifactNode getDigest() { result.asElement() = instance.getDigestArtifact() }

    override NodeBase getChild(string key) {
      result = super.getChild(key)
      or
      // [KNOWN_OR_UNKNOWN]
      key = "Digest" and
      if exists(this.getDigest()) then result = this.getDigest() else result = this
    }
  }

  newtype THashType =
    BLAKE2B() or
    BLAKE2S() or
    GOSTHash() or
    MD2() or
    MD4() or
    MD5() or
    MDC2() or
    POLY1305() or
    SHA1() or
    SHA2() or
    SHA3() or
    SHAKE() or
    SM3() or
    RIPEMD160() or
    WHIRLPOOL() or
    OtherHashType()

  /**
   * A hashing algorithm that transforms variable-length input into a fixed-size hash value.
   */
  final class HashAlgorithmNode extends AlgorithmNode, THashAlgorithm {
    HashAlgorithmInstanceOrValueConsumer instance;

    HashAlgorithmNode() { this = THashAlgorithm(instance) }

    override string getInternalType() { result = "HashAlgorithm" }

    override LocatableElement asElement() { result = instance }

    override string getRawAlgorithmName() { result = instance.asAlg().getRawHashAlgorithmName() }

    final predicate hashTypeToNameMapping(THashType type, string name) {
      type instanceof BLAKE2B and name = "BLAKE2B"
      or
      type instanceof BLAKE2S and name = "BLAKE2S"
      or
      type instanceof RIPEMD160 and name = "RIPEMD160"
      or
      type instanceof MD2 and name = "MD2"
      or
      type instanceof MD4 and name = "MD4"
      or
      type instanceof MD5 and name = "MD5"
      or
      type instanceof POLY1305 and name = "POLY1305"
      or
      type instanceof SHA1 and name = "SHA1"
      or
      type instanceof SHA2 and name = "SHA2"
      or
      type instanceof SHA3 and name = "SHA3"
      or
      type instanceof SHAKE and name = "SHAKE"
      or
      type instanceof SM3 and name = "SM3"
      or
      type instanceof WHIRLPOOL and name = "WHIRLPOOL"
    }

    /**
     * Gets the type of this hashing algorithm, e.g., MD5 or SHA.
     *
     * When modeling a new hashing algorithm, use this predicate to specify the type of the algorithm.
     */
    THashType getHashFamily() { result = instance.asAlg().getHashFamily() }

    override string getAlgorithmName() { this.hashTypeToNameMapping(this.getHashFamily(), result) }

    int getDigestLength() { result = instance.asAlg().getDigestLength() }

    final override predicate properties(string key, string value, Location location) {
      super.properties(key, value, location)
      or
      // [KNOWN_OR_UNKNOWN]
      key = "DigestSize" and
      if exists(this.getDigestLength())
      then value = this.getDigestLength().toString() and location = this.getLocation()
      else (
        value instanceof UnknownPropertyValue and location instanceof UnknownLocation
      )
    }
  }

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

  private predicate isBrainpoolCurve(string curveName, int keySize) {
    // ALL BRAINPOOL CURVES
    keySize in [160, 192, 224, 256, 320, 384, 512] and
    (
      curveName = "BRAINPOOLP" + keySize.toString() + "R1"
      or
      curveName = "BRAINPOOLP" + keySize.toString() + "T1"
    )
  }

  private predicate isSecCurve(string curveName, int keySize) {
    // ALL SEC CURVES
    keySize in [112, 113, 128, 131, 160, 163, 192, 193, 224, 233, 239, 256, 283, 384, 409, 521, 571] and
    exists(string suff | suff in ["R1", "R2", "K1"] |
      curveName = "SECT" + keySize.toString() + suff or
      curveName = "SECP" + keySize.toString() + suff
    )
  }

  private predicate isC2Curve(string curveName, int keySize) {
    // ALL C2 CURVES
    keySize in [163, 176, 191, 208, 239, 272, 304, 359, 368, 431] and
    exists(string pre, string suff |
      pre in ["PNB", "ONB", "TNB"] and suff in ["V1", "V2", "V3", "V4", "V5", "W1", "R1"]
    |
      curveName = "C2" + pre + keySize.toString() + suff
    )
  }

  private predicate isPrimeCurve(string curveName, int keySize) {
    // ALL PRIME CURVES
    keySize in [192, 239, 256] and
    exists(string suff | suff in ["V1", "V2", "V3"] |
      curveName = "PRIME" + keySize.toString() + suff
    )
  }

  private predicate isNumsCurve(string curveName, int keySize) {
    // ALL NUMS CURVES
    keySize in [256, 384, 512] and
    exists(string suff | suff in ["T1"] | curveName = "NUMSP" + keySize.toString() + suff)
  }

  bindingset[curveName]
  predicate isEllipticCurveAlgorithmName(string curveName) {
    isEllipticCurveAlgorithm(curveName, _, _)
  }

  /**
   * Holds if `name` corresponds to a known elliptic curve.
   */
  bindingset[rawName]
  predicate isEllipticCurveAlgorithm(string rawName, int keySize, TEllipticCurveType curveFamily) {
    exists(string curveName | curveName = rawName.toUpperCase() |
      isSecCurve(curveName, keySize) and curveFamily = SEC()
      or
      isBrainpoolCurve(curveName, keySize) and curveFamily = BRAINPOOL()
      or
      isC2Curve(curveName, keySize) and curveFamily = C2()
      or
      isPrimeCurve(curveName, keySize) and curveFamily = PRIME()
      or
      isNumsCurve(curveName, keySize) and curveFamily = NUMS()
      or
      curveName = "ES256" and keySize = 256 and curveFamily = ES()
      or
      curveName = "CURVE25519" and keySize = 255 and curveFamily = CURVE25519()
      or
      curveName = "X25519" and keySize = 255 and curveFamily = CURVE25519()
      or
      curveName = "ED25519" and keySize = 255 and curveFamily = CURVE25519()
      or
      curveName = "CURVE448" and keySize = 448 and curveFamily = CURVE448()
      or
      curveName = "ED448" and keySize = 448 and curveFamily = CURVE448()
      or
      curveName = "X448" and keySize = 448 and curveFamily = CURVE448()
      or
      curveName = "SM2" and keySize in [256, 512] and curveFamily = SM2()
    )
  }

  final class EllipticCurveNode extends AlgorithmNode, TEllipticCurveAlgorithm {
    EllipticCurveAlgorithmInstanceOrValueConsumer instance;

    EllipticCurveNode() { this = TEllipticCurveAlgorithm(instance) }

    override string getInternalType() { result = "EllipticCurveAlgorithm" }

    final override string getRawAlgorithmName() {
      result = instance.asAlg().getRawEllipticCurveAlgorithmName()
    }

    // NICK QUESTION: do I repeat the key size and curve family predicates here as wrappers of the instance?
    override LocatableElement asElement() { result = instance }

    TEllipticCurveType getEllipticCurveFamily() {
      result = instance.asAlg().getEllipticCurveFamily()
    }

    override predicate properties(string key, string value, Location location) {
      super.properties(key, value, location)
      or
      // [ONLY_KNOWN]
      key = "KeySize" and
      value = instance.asAlg().getKeySize() and
      location = this.getLocation()
      or
      key = "StdCurveName" and
      value = instance.asAlg().getStandardCurveName().toUpperCase() and
      location = this.getLocation()
    }

    override string getAlgorithmName() { result = this.getRawAlgorithmName().toUpperCase() }
    // /**
    //  * Mandating that for Elliptic Curves specifically, users are responsible
    //  * for providing as the 'raw' name, the official name of the algorithm.
    //  *
    //  * Casing doesn't matter, we will enforce further naming restrictions on
    //  * `getAlgorithmName` by default.
    //  *
    //  * Rationale: elliptic curve names can have a lot of variation in their components
    //  * (e.g., "secp256r1" vs "P-256"), trying to produce generalized set of properties
    //  * is possible to capture all cases, but such modeling is likely not necessary.
    //  * if all properties need to be captured, we can reassess how names are generated.
    //  */
    // abstract override string getRawAlgorithmName();
  }

  abstract class KEMAlgorithm extends TKeyEncapsulationAlgorithm, AlgorithmNode {
    final override string getInternalType() { result = "KeyEncapsulationAlgorithm" }
  }
}
