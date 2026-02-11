overlay[local?]
module;

private import java as Language
private import semmle.code.java.security.InsecureRandomnessQuery
private import semmle.code.java.security.RandomQuery
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.FlowSources
private import codeql.quantum.experimental.Model

private class UnknownLocation extends Language::Location {
  UnknownLocation() { this.getFile().getAbsolutePath() = "" }
}

/**
 * A dummy location which is used when something doesn't have a location in
 * the source code but needs to have a `Location` associated with it. There
 * may be several distinct kinds of unknown locations. For example: one for
 * expressions, one for statements and one for other program elements.
 */
private class UnknownDefaultLocation extends UnknownLocation {
  UnknownDefaultLocation() { locations_default(this, _, 0, 0, 0, 0) }
}

module CryptoInput implements InputSig<Language::Location> {
  class DataFlowNode = DataFlow::Node;

  class LocatableElement = Language::Element;

  class UnknownLocation = UnknownDefaultLocation;

  string locationToFileBaseNameAndLineNumberString(Location location) {
    result = location.toString()
  }

  LocatableElement dfn_to_element(DataFlow::Node node) {
    result = node.asExpr() or
    result = node.asParameter()
  }

  predicate artifactOutputFlowsToGenericInput(
    DataFlow::Node artifactOutput, DataFlow::Node otherInput
  ) {
    ArtifactFlow::flow(artifactOutput, otherInput)
  }
}

// Instantiate the `CryptographyBase` module
module Crypto = CryptographyBase<Language::Location, CryptoInput>;

// Definitions of various generic sources
final class DefaultFlowSource = SourceNode;

final class DefaultRemoteFlowSource = RemoteFlowSource;

private class GenericUnreferencedParameterSource extends Crypto::GenericUnreferencedParameterSource {
  GenericUnreferencedParameterSource() {
    exists(Parameter p |
      this = p and
      not exists(p.getAnArgument())
      // or
      // // TODO: this is test code which causes regression in unit tests, but will
      // // find sources where ordinarily a source might be missing
      // // If all calls to a function occur in a test file, ignore those calls
      // // and consider the parameter to the function a potential source as well.
      // forall(Call testCall | testCall.getCallee() = p.getCallable() |
      //   testCall.getFile().getBaseName().toUpperCase().matches("%TEST%")
      // )
    )
  }

  override predicate flowsTo(Crypto::FlowAwareElement other) {
    GenericDataSourceFlow::flow(this.getOutputNode(), other.getInputNode())
  }

  override DataFlow::Node getOutputNode() { result.asParameter() = this }

  override string getAdditionalDescription() { result = this.toString() }
}

private class GenericLocalDataSource extends Crypto::GenericLocalDataSource {
  GenericLocalDataSource() {
    any(DefaultFlowSource src | not src instanceof DefaultRemoteFlowSource).asExpr() = this
  }

  override DataFlow::Node getOutputNode() { result.asExpr() = this }

  override predicate flowsTo(Crypto::FlowAwareElement other) {
    GenericDataSourceFlow::flow(this.getOutputNode(), other.getInputNode())
  }

  override string getAdditionalDescription() { result = this.toString() }
}

private class GenericRemoteDataSource extends Crypto::GenericRemoteDataSource {
  GenericRemoteDataSource() { any(DefaultRemoteFlowSource src).asExpr() = this }

  override DataFlow::Node getOutputNode() { result.asExpr() = this }

  override predicate flowsTo(Crypto::FlowAwareElement other) {
    GenericDataSourceFlow::flow(this.getOutputNode(), other.getInputNode())
  }

  override string getAdditionalDescription() { result = this.toString() }
}

import semmle.code.java.frameworks.Properties
private import semmle.code.configfiles.ConfigFiles

/**
 * A class to represent constants in Java code, either literals or
 * values retrieved from properties files.
 * Java CodeQL does not consider the values of known properties to be literals,
 * hence we need to model both literals and property calls.
 */
class JavaConstant extends Expr {
  string value;

  JavaConstant() {
    // If arg 0 in a getProperty call, consider it a literal only if
    // we haven't resolved it to a known property value, otherwise
    // use the resolved config value.
    // If getProperty is used, always assume the default value is potentially used.
    // CAVEAT/ASSUMPTION: this assumes the literal is immediately known at arg0
    // of a getProperty call.
    // also if the properties file is reloaded in a way where the reloaded file
    // wouldn't have the property but the original does, we would erroneously
    // consider the literal to be mapped to that property value.
    exists(ConfigPair p, PropertiesGetPropertyMethodCall c |
      c.getArgument(0).(Literal).getValue() = p.getNameElement().getName() and
      value = p.getValueElement().getValue() and
      this = c
    )
    or
    // in this case, the property value is not known, use the literal property name as the value
    exists(PropertiesGetPropertyMethodCall c |
      value = c.getArgument(0).(Literal).getValue() and
      not exists(ConfigPair p |
        c.getArgument(0).(Literal).getValue() = p.getNameElement().getName()
      ) and
      this = c
    )
    or
    // in this case, there is not propery getter, we just have a literal
    not exists(PropertiesGetPropertyMethodCall c | c.getArgument(0) = this) and
    value = this.(Literal).getValue()
  }

  string getValue() { result = value }
}

private class ConstantDataSourceLiteral extends Crypto::GenericConstantSourceInstance instanceof JavaConstant
{
  ConstantDataSourceLiteral() {
    // TODO: this is an API specific workaround for JCA, as 'EC' is a constant that may be used
    // where typical algorithms are specified, but EC specifically means set up a
    // default curve container, that will later be specified explicitly (or if not a default)
    // curve is used.
    this.getValue() != "EC"
  }

  override DataFlow::Node getOutputNode() { result.asExpr() = this }

  override predicate flowsTo(Crypto::FlowAwareElement other) {
    // TODO: separate config to avoid blowing up data-flow analysis
    GenericDataSourceFlow::flow(this.getOutputNode(), other.getInputNode())
  }

  override string getAdditionalDescription() { result = this.toString() }
}

private class ConstantDataSourceArrayInitializer extends Crypto::GenericConstantSourceInstance instanceof ArrayInit
{
  ConstantDataSourceArrayInitializer() { this.getAnInit() instanceof Literal }

  override DataFlow::Node getOutputNode() { result.asExpr() = this }

  override predicate flowsTo(Crypto::FlowAwareElement other) {
    // TODO: separate config to avoid blowing up data-flow analysis
    GenericDataSourceFlow::flow(this.getOutputNode(), other.getInputNode())
  }

  override string getAdditionalDescription() { result = this.toString() }
}

/**
 * An instance of random number generation, modeled as the expression
 * tied to an output node (i.e., the result of the source of randomness)
 */
abstract class RandomnessInstance extends Crypto::RandomNumberGenerationInstance {
  override DataFlow::Node getOutputNode() { result.asExpr() = this }
}

class SecureRandomnessInstance extends RandomnessInstance {
  RandomDataSource source;

  SecureRandomnessInstance() {
    this = source.getOutput() and
    source.getSourceOfRandomness() instanceof SecureRandomNumberGenerator
  }

  override string getGeneratorName() { result = source.getSourceOfRandomness().getQualifiedName() }
}

class InsecureRandomnessInstance extends RandomnessInstance {
  RandomDataSource source;

  InsecureRandomnessInstance() {
    any(InsecureRandomnessSource src).asExpr() = this and source.getOutput() = this
  }

  override string getGeneratorName() { result = source.getSourceOfRandomness().getQualifiedName() }
}

/**
 * An additional flow step in generic data-flow configurations.
 * Where a step is an edge between nodes `n1` and `n2`,
 * `this` = `n1` and `getOutput()` = `n2`.
 *
 * FOR INTERNAL MODELING USE ONLY.
 */
abstract class AdditionalFlowInputStep extends DataFlow::Node {
  abstract DataFlow::Node getOutput();

  final DataFlow::Node getInput() { result = this }
}

/**
 * Generic data source to node input configuration
 */
module GenericDataSourceFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source = any(Crypto::GenericSourceInstance i).getOutputNode()
  }

  predicate isSink(DataFlow::Node sink) {
    sink = any(Crypto::FlowAwareElement other).getInputNode()
  }

  predicate isBarrierOut(DataFlow::Node node) {
    node = any(Crypto::FlowAwareElement element).getInputNode()
  }

  predicate isBarrierIn(DataFlow::Node node) {
    node = any(Crypto::FlowAwareElement element).getOutputNode()
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    node1.(AdditionalFlowInputStep).getOutput() = node2
    or
    exists(MethodCall m |
      m.getMethod().hasQualifiedName("java.lang", "String", "getBytes") and
      node1.asExpr() = m.getQualifier() and
      node2.asExpr() = m
    )
  }
}

module ArtifactFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source = any(Crypto::ArtifactInstance artifact).getOutputNode()
  }

  predicate isSink(DataFlow::Node sink) {
    sink = any(Crypto::FlowAwareElement other).getInputNode()
  }

  predicate isBarrierOut(DataFlow::Node node) {
    node = any(Crypto::FlowAwareElement element).getInputNode()
  }

  predicate isBarrierIn(DataFlow::Node node) {
    node = any(Crypto::FlowAwareElement element).getOutputNode()
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    node1.(AdditionalFlowInputStep).getOutput() = node2
    or
    exists(MethodCall m |
      m.getMethod().hasQualifiedName("java.lang", "String", "getBytes") and
      node1.asExpr() = m.getQualifier() and
      node2.asExpr() = m
    )
  }
}

module GenericDataSourceFlow = TaintTracking::Global<GenericDataSourceFlowConfig>;

module ArtifactFlow = TaintTracking::Global<ArtifactFlowConfig>;

// Import library-specific modeling
import JCA
