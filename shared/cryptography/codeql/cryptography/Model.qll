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

  LocatableElement dfn_to_element(DataFlowNode node);

  predicate artifactOutputFlowsToGenericInput(
    DataFlowNode artifactOutput, DataFlowNode otherFlowAwareInput
  );
}

module CryptographyBase<LocationSig Location, InputSig<Location> Input> {
  final class LocatableElement = Input::LocatableElement;

  final class UnknownLocation = Input::UnknownLocation;

  final class DataFlowNode = Input::DataFlowNode;

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
              else parsed = "(" + value + "," + location.toString() + ")"
            )
          |
            parsed
          ), ","
      )
  }

  NodeBase getPassthroughNodeChild(NodeBase node) { result = node.getChild(_) }

  predicate isPassthroughNode(NodeBase node) {
    node.asElement() instanceof ArtifactConsumerAndInstance
  }

  predicate nodes_graph_impl(NodeBase node, string key, string value) {
    not node.isExcludedFromGraph() and
    not isPassthroughNode(node) and // TODO: punt to fix known unknowns for passthrough nodes
    (
      key = "semmle.label" and
      value = node.toString()
      or
      // CodeQL's DGML output does not include a location
      key = "Location" and
      value = "demo" // node.getLocation().toString()
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
     * Gets the output node for this artifact, which should usually be the same as `this`.
     */
    abstract DataFlowNode getOutputNode();

    /**
     * Gets the input node for this artifact.
     *
     * If `getInput` is implemented as `none()`, the artifact will not have inbound flow analysis.
     */
    abstract DataFlowNode getInputNode();

    /**
     * Holds if this artifact flows to `other`.
     *
     * This predicate should be defined generically per-language with library-specific extension support.
     * The expected implementation is to perform flow analysis from this artifact's output to another artifact's input.
     * The `other` argument should be one or more `ArtifactLocatableElement` that are sinks of the flow.
     *
     * If `flowsTo` is implemented as `none()`, the artifact will not have outbound flow analysis.
     */
    abstract predicate flowsTo(FlowAwareElement other);
  }

  /**
   * An element that represents a _known_ cryptographic asset with a determinable value OR an artifact.
   *
   * CROSS PRODUCT WARNING: Do not model any *other* element that is a `FlowAwareElement` to the same
   * instance in the database, as every other `KnownElement` will share that output artifact's flow.
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
  abstract class AlgorithmInstance extends KnownElement {
    /**
     * Gets the raw name as it appears in source, e.g., "AES/CBC/PKCS7Padding".
     * This name is not parsed or formatted.
     */
    abstract string getRawAlgorithmName();
  }

  /**
   * An element that represents an _unknown_ data-source with a non-statically determinable value.
   */
  abstract class GenericDataSourceInstance extends FlowAwareElement {
    final override DataFlowNode getInputNode() { none() }

    abstract string getInternalType();

    string getAdditionalDescription() { none() }
  }

  abstract class GenericConstantOrAllocationSource extends GenericDataSourceInstance {
    final override string getInternalType() { result = "ConstantData" } // TODO: toString of source?
  }

  abstract class GenericExternalCallSource extends GenericDataSourceInstance {
    final override string getInternalType() { result = "ExternalCall" } // TODO: call target name or toString of source?
  }

  abstract class GenericRemoteDataSource extends GenericDataSourceInstance {
    final override string getInternalType() { result = "RemoteData" } // TODO: toString of source?
  }

  abstract class GenericLocalDataSource extends GenericDataSourceInstance {
    final override string getInternalType() { result = "LocalData" } // TODO: toString of source?
  }

  /**
   * An element that consumes _known_ or _unknown_ cryptographic assets.
   *
   * Note that known assets are to be modeled explicitly with the `getAKnownSource` predicate, whereas
   * unknown assets are modeled implicitly via flow analysis from any `GenericDataSourceInstance` to this element.
   *
   * A consumer can consume multiple instances and types of assets at once, e.g., both a `PaddingAlgorithm` and `CipherAlgorithm`.
   */
  abstract private class ConsumerElement extends FlowAwareElement {
    abstract KnownElement getAKnownSource();

    override predicate flowsTo(FlowAwareElement other) { none() }

    override DataFlowNode getOutputNode() { none() }

    // for internal use only
    final GenericDataSourceInstance getAnUnknownSource() {
      result.flowsTo(this) and not result = this.getAKnownSource()
    }

    final GenericSourceNode getAnUnknownSourceNode() {
      result.asElement() = this.getAnUnknownSource()
    }

    final NodeBase getAKnownSourceNode() { result.asElement() = this.getAKnownSource() }

    final LocatableElement getASource() {
      result = this.getAnUnknownSource() or
      result = this.getAKnownSource()
    }
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
    DataFlowNode inputNode;

    NonceArtifactConsumer() {
      exists(CipherOperationInstance op | inputNode = op.getNonceConsumer()) and
      this = Input::dfn_to_element(inputNode)
    }

    final override DataFlowNode getInputNode() { result = inputNode }
  }

  final private class CipherInputArtifactConsumer extends ArtifactConsumerAndInstance {
    DataFlowNode inputNode;

    CipherInputArtifactConsumer() {
      exists(CipherOperationInstance op | inputNode = op.getInputConsumer()) and
      this = Input::dfn_to_element(inputNode)
    }

    final override DataFlowNode getInputNode() { result = inputNode }
  }

  // Output artifacts are determined solely by the element that produces them.
  // Implementation guidance: these *do* need to be defined generically at the language-level
  // in order for a flowsTo to be defined. At the per-modeling-instance level, extend that language-level class!
  abstract class OutputArtifactInstance extends ArtifactInstance {
    override predicate isConsumerArtifact() { none() }

    override DataFlowNode getInputNode() { none() }
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

    override predicate flowsTo(FlowAwareElement other) {
      Input::artifactOutputFlowsToGenericInput(this.getOutputNode(), other.getInputNode())
    }
  }

  final class KeyArtifactConsumer extends KeyArtifactInstance, ArtifactConsumerAndInstance {
    DataFlowNode inputNode;

    // TODO: key type hint? e.g. hint: private || public
    KeyArtifactConsumer() {
      exists(CipherOperationInstance op | inputNode = op.getKeyConsumer()) and
      this = Input::dfn_to_element(inputNode)
    }

    override KeyArtifactType getKeyType() { result instanceof TUnknownKeyType }

    final override DataFlowNode getInputNode() { result = inputNode }
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
    abstract DataFlowNode getNonceConsumer();

    /**
     * Gets the consumer of plaintext or ciphertext input associated with this cipher operation.
     */
    abstract DataFlowNode getInputConsumer();

    /**
     * Gets the consumer of a key.
     */
    abstract DataFlowNode getKeyConsumer();

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
    abstract HashAlgorithmInstance getHashAlgorithm();

    /**
     * Gets the mask generation function used in this padding scheme.
     */
    abstract HashAlgorithmInstance getMaskGenerationFunction();
  }

  abstract class KeyEncapsulationOperationInstance extends OperationInstance { }

  abstract class KeyEncapsulationAlgorithmInstance extends AlgorithmInstance { }

  abstract class EllipticCurveAlgorithmInstance extends AlgorithmInstance { }

  abstract class HashOperationInstance extends OperationInstance {
    abstract DigestArtifactInstance getDigestArtifact();
  }

  abstract class HashAlgorithmInstance extends AlgorithmInstance {
    /**
     * Gets the type of this digest algorithm, e.g., "SHA1", "SHA2", "MD5" etc.
     */
    abstract THashType getHashFamily();
  }

  abstract class KeyDerivationOperationInstance extends OperationInstance { }

  abstract class KeyDerivationAlgorithmInstance extends AlgorithmInstance { }

  abstract private class KeyCreationOperationInstance extends OperationInstance {
    abstract string getKeyCreationTypeDescription();

    /**
     * Gets the key artifact produced by this operation.
     */
    abstract DataFlowNode getOutputKeyArtifact();

    /**
     * Gets the key artifact type produced.
     */
    abstract KeyArtifactType getOutputKeyType();

    /**
     * Gets the key size of the key produced by this operation.
     */
    string getKeySize() { none() } // TODO: punt, might need a generic value consumer?
  }

  abstract class KeyGenerationOperationInstance extends KeyCreationOperationInstance {
    final override string getKeyCreationTypeDescription() { result = "KeyGeneration" }
  }

  abstract class KeyLoadOperationInstance extends KeyCreationOperationInstance {
    final override string getKeyCreationTypeDescription() { result = "KeyLoad" }
  }

  private signature class AlgorithmInstanceType instanceof AlgorithmInstance;

  module AlgorithmInstanceOrValueConsumer<AlgorithmInstanceType Alg> {
    class Union extends LocatableElement {
      Union() {
        this instanceof Alg
        or
        this instanceof AlgorithmValueConsumer and
        not exists(this.(AlgorithmValueConsumer).getASource())
      }

      Alg asAlg() { result = this }

      AlgorithmValueConsumer asAVC() { result = this }
    }
  }

  class CipherAlgorithmInstanceOrValueConsumer =
    AlgorithmInstanceOrValueConsumer<CipherAlgorithmInstance>::Union;

  class HashAlgorithmInstanceOrValueConsumer =
    AlgorithmInstanceOrValueConsumer<HashAlgorithmInstance>::Union;

  newtype TNode =
    // Artifacts (data that is not an operation or algorithm, e.g., a key)
    TDigest(DigestArtifactInstance e) or
    TKey(KeyArtifactInstance e) or
    TNonce(NonceArtifactConsumer e) or
    TCipherInput(CipherInputArtifactConsumer e) or
    TCipherOutput(CipherOutputArtifactInstance e) or
    TRandomNumberGeneration(RandomNumberGenerationInstance e) { e.flowsTo(_) } or
    // Operations (e.g., hashing, encryption)
    THashOperation(HashOperationInstance e) or
    TKeyDerivationOperation(KeyDerivationOperationInstance e) or
    TCipherOperation(CipherOperationInstance e) or
    TKeyEncapsulationOperation(KeyEncapsulationOperationInstance e) or
    // Key Creation Operations
    TKeyCreationOperation(KeyCreationOperationInstance e) or
    // Algorithms (e.g., SHA-256, AES)
    TCipherAlgorithm(CipherAlgorithmInstanceOrValueConsumer e) or
    TEllipticCurveAlgorithm(EllipticCurveAlgorithmInstance e) or
    THashAlgorithm(HashAlgorithmInstanceOrValueConsumer e) or
    TKeyDerivationAlgorithm(KeyDerivationAlgorithmInstance e) or
    TKeyEncapsulationAlgorithm(KeyEncapsulationAlgorithmInstance e) or
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
    // Unknown source node
    TGenericSourceNode(GenericDataSourceInstance e) { e.flowsTo(_) }

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
   * relevant to analysis in terms of its underlying value. Therefore, an RNG seed is a node; a key size is not.
   *
   * _Example 2_: A salt for a key derivation function *is* an `ArtifactNode`.
   *
   * _Example 3_: The iteration count of a key derivation function is *not* a node.
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
   * A generic source node is a source of data that is not resolvable to a specific value or type.
   */
  private class GenericSourceNode extends NodeBase, TGenericSourceNode {
    GenericDataSourceInstance instance;

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
      not exists(NodeBase other | not other = this and other.getChild(_) = this)
    }
  }

  class AssetNode = NodeBase;

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
      edgeName = this.getSourceNodeRelationship() and // only holds if not set to none()
      if exists(this.getSourceNode()) then result = this.getSourceNode() else result = this
    }
  }

  /**
   * A nonce or initialization vector
   */
  final class NonceArtifactNode extends ArtifactNode, TNonce {
    NonceArtifactConsumer instance;

    NonceArtifactNode() { this = TNonce(instance) }

    final override string getInternalType() { result = "Nonce" }

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
  }

  /**
   * Input text to a cipher operation
   */
  final class CipherInputNode extends ArtifactNode, TCipherInput {
    CipherInputArtifactConsumer instance;

    CipherInputNode() { this = TCipherInput(instance) }

    final override string getInternalType() { result = "CipherInput" }

    override LocatableElement asElement() { result = instance }
  }

  /**
   * A source of random number generation
   */
  final class RandomNumberGenerationNode extends ArtifactNode, TRandomNumberGeneration {
    RandomNumberGenerationInstance instance;

    RandomNumberGenerationNode() { this = TRandomNumberGeneration(instance) }

    final override string getInternalType() { result = "RandomNumberGeneration" }

    override LocatableElement asElement() { result = instance }
  }

  /**
   * A cryptographic key, such as a symmetric key or asymmetric key pair.
   */
  final class KeyArtifactNode extends ArtifactNode, TKey {
    KeyArtifactInstance instance;

    KeyArtifactNode() { this = TKey(instance) }

    final override string getInternalType() { result = "Key" }

    override LocatableElement asElement() { result = instance }

    /**
     * Gets the algorithm or unknown source nodes consumed as an algorithm associated with this operation.
     */
    NodeBase getAnAlgorithmOrUnknown() {
      result = this.getAKnownAlgorithm() or
      result =
        this.asElement().(OperationInstance).getAnAlgorithmValueConsumer().getAnUnknownSourceNode()
    }

    /**
     * Gets a known algorithm associated with this operation
     */
    CipherAlgorithmNode getAKnownAlgorithm() {
      result =
        this.asElement().(OperationInstance).getAnAlgorithmValueConsumer().getAKnownSourceNode()
    }

    override NodeBase getChild(string edgeName) {
      result = super.getChild(edgeName)
      or
      // [KNOWN_OR_UNKNOWN]
      edgeName = "Algorithm" and
      if exists(this.getAnAlgorithmOrUnknown())
      then result = this.getAnAlgorithmOrUnknown()
      else result = this
    }

    override predicate properties(string key, string value, Location location) {
      super.properties(key, value, location)
      or
      // [ONLY_KNOWN]
      key = "KeyType" and
      value = instance.getKeyType().toString() and
      location = this.getLocation()
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

  /**
   * A cryptographic operation, such as hashing or encryption.
   */
  abstract class OperationNode extends AssetNode { }

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

  final class KeyCreationOperationNode extends OperationNode, TKeyCreationOperation {
    KeyCreationOperationInstance instance;

    KeyCreationOperationNode() { this = TKeyCreationOperation(instance) }

    override LocatableElement asElement() { result = instance }

    override string getInternalType() { result = instance.getKeyCreationTypeDescription() }
  }

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

    /**
     * Gets the algorithm or unknown source nodes consumed as an algorithm associated with this operation.
     */
    NodeBase getACipherAlgorithmOrUnknown() {
      result = this.getAKnownCipherAlgorithm() or
      result =
        this.asElement().(OperationInstance).getAnAlgorithmValueConsumer().getAnUnknownSourceNode()
    }

    /**
     * Gets a known algorithm associated with this operation
     */
    CipherAlgorithmNode getAKnownCipherAlgorithm() {
      result =
        this.asElement().(OperationInstance).getAnAlgorithmValueConsumer().getAKnownSourceNode()
    }

    CipherOperationSubtype getCipherOperationSubtype() {
      result = instance.getCipherOperationSubtype()
    }

    NonceArtifactNode getANonce() {
      result.asElement() =
        Input::dfn_to_element(this.asElement().(CipherOperationInstance).getNonceConsumer())
    }

    CipherInputNode getAnInputArtifact() {
      result.asElement() =
        Input::dfn_to_element(this.asElement().(CipherOperationInstance).getInputConsumer())
    }

    CipherOutputNode getAnOutputArtifact() {
      result.asElement() = this.asElement().(CipherOperationInstance).getOutputArtifact()
    }

    KeyArtifactNode getAKey() {
      result.asElement() =
        Input::dfn_to_element(this.asElement().(CipherOperationInstance).getKeyConsumer())
    }

    override NodeBase getChild(string key) {
      result = super.getChild(key)
      or
      // [KNOWN_OR_UNKNOWN]
      key = "Algorithm" and
      if exists(this.getACipherAlgorithmOrUnknown())
      then result = this.getACipherAlgorithmOrUnknown()
      else result = this
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
      or
      type instanceof OtherMode and name = this.getRawAlgorithmName()
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
      or
      type instanceof OtherPadding and name = this.getRawAlgorithmName()
    }

    override string getAlgorithmName() { this.paddingToNameMapping(this.getPaddingType(), result) }

    override string getRawAlgorithmName() { result = instance.getRawPaddingAlgorithmName() }
  }

  class OAEPPaddingAlgorithmNode extends PaddingAlgorithmNode {
    override OAEPPaddingAlgorithmInstance instance;

    OAEPPaddingAlgorithmNode() { this = TPaddingAlgorithm(instance) }

    HashAlgorithmNode getHashAlgorithm() { result.asElement() = instance.getHashAlgorithm() }

    HashAlgorithmNode getMaskGenerationFunction() {
      result.asElement() = instance.getMaskGenerationFunction()
    }

    override NodeBase getChild(string edgeName) {
      result = super.getChild(edgeName)
      or
      // [KNOWN_OR_UNKNOWN]
      edgeName = "MD" and
      if exists(this.getHashAlgorithm()) then result = this.getHashAlgorithm() else result = this
      or
      // [KNOWN_OR_UNKNOWN]
      edgeName = "MGF" and
      if exists(this.getMaskGenerationFunction())
      then result = this.getMaskGenerationFunction()
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

    final override string getRawAlgorithmName() { result = instance.asAlg().getRawAlgorithmName() }

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
      name = this.getRawAlgorithmName() and
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

    /**
     * Gets the algorithm or unknown source nodes consumed as an algorithm associated with this operation.
     */
    NodeBase getAHashAlgorithmOrUnknown() {
      result = this.getAKnownHashAlgorithm() or
      result =
        this.asElement().(OperationInstance).getAnAlgorithmValueConsumer().getAnUnknownSourceNode()
    }

    /**
     * Gets a known algorithm associated with this operation
     */
    HashAlgorithmNode getAKnownHashAlgorithm() {
      result =
        this.asElement().(OperationInstance).getAnAlgorithmValueConsumer().getAKnownSourceNode()
    }

    /**
     * Gets the output digest node
     */
    DigestArtifactNode getDigest() {
      result.asElement() = this.asElement().(HashOperationInstance).getDigestArtifact()
    }

    override NodeBase getChild(string edgeName) {
      result = super.getChild(edgeName)
      or
      // [KNOWN_OR_UNKNOWN]
      edgeName = "Algorithm" and
      if exists(this.getAHashAlgorithmOrUnknown())
      then result = this.getAHashAlgorithmOrUnknown()
      else result = this
      or
      // [KNOWN_OR_UNKNOWN]
      edgeName = "Digest" and
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

    override string getRawAlgorithmName() { result = instance.asAlg().getRawAlgorithmName() }

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
      key = "DigestSize" and
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
  abstract class KeyDerivationOperationNode extends OperationNode, TKeyDerivationOperation {
    final override Location getLocation() {
      exists(LocatableElement le | this = TKeyDerivationOperation(le) and result = le.getLocation())
    }

    override string getInternalType() { result = "KeyDerivationOperation" }
  }

  /**
   * An algorithm that derives one or more keys from an input value.
   *
   * Only use this class to model UNKNOWN key derivation algorithms.
   *
   * For known algorithms, use the specialized classes, e.g., `HKDF` and `PKCS12KDF`.
   */
  abstract class KeyDerivationAlgorithmNode extends AlgorithmNode, TKeyDerivationAlgorithm {
    final override Location getLocation() {
      exists(LocatableElement le | this = TKeyDerivationAlgorithm(le) and result = le.getLocation())
    }

    override string getInternalType() { result = "KeyDerivationAlgorithm" }

    override string getAlgorithmName() { result = this.getRawAlgorithmName() }
  }

  /**
   * An algorithm that derives one or more keys from an input value, using a configurable digest algorithm.
   */
  abstract private class KeyDerivationWithDigestParameterNode extends KeyDerivationAlgorithmNode {
    abstract HashAlgorithmNode getHashAlgorithm();

    override NodeBase getChild(string edgeName) {
      result = super.getChild(edgeName)
      or
      (
        // [KNOWN_OR_UNKNOWN]
        edgeName = "Uses" and
        if exists(this.getHashAlgorithm()) then result = this.getHashAlgorithm() else result = this
      )
    }
  }

  /**
   * HKDF key derivation function
   */
  abstract class HKDFNode extends KeyDerivationWithDigestParameterNode {
    final override string getAlgorithmName() { result = "HKDF" }
  }

  /**
   * PBKDF2 key derivation function
   */
  abstract class PBKDF2Node extends KeyDerivationWithDigestParameterNode {
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
        key = "Iterations" and
        if exists(this.getIterationCount(location))
        then value = this.getIterationCount(location)
        else (
          value instanceof UnknownPropertyValue and location instanceof UnknownLocation
        )
      )
      or
      (
        // [KNOWN_OR_UNKNOWN]
        key = "KeyLength" and
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
  abstract class PKCS12KDF extends KeyDerivationWithDigestParameterNode {
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
        key = "Iterations" and
        if exists(this.getIterationCount(location))
        then value = this.getIterationCount(location)
        else (
          value instanceof UnknownPropertyValue and location instanceof UnknownLocation
        )
      )
      or
      (
        // [KNOWN_OR_UNKNOWN]
        key = "IdByte" and
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
  abstract class SCRYPT extends KeyDerivationAlgorithmNode {
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
        key = "KeyLength" and
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

  abstract class EllipticCurve extends AlgorithmNode, TEllipticCurveAlgorithm {
    abstract string getKeySize(Location location);

    abstract TEllipticCurveType getCurveFamily();

    override predicate properties(string key, string value, Location location) {
      super.properties(key, value, location)
      or
      // [KNOWN_OR_UNKNOWN]
      key = "KeySize" and
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

  abstract class KEMAlgorithm extends TKeyEncapsulationAlgorithm, AlgorithmNode {
    final override string getInternalType() { result = "KeyEncapsulationAlgorithm" }
  }
}
