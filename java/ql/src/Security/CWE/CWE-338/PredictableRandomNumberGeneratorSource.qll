import java
import types
import StrictPredictableRandomTaintTracker
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TypeFlow
import semmle.code.java.dataflow.TaintTracking2

abstract class PredictableRandomFlowSource extends DataFlow::Node { }

abstract class PredictableRandomMethodAccess extends MethodAccess { }

private class PredictableApacheRandomStringUtilsMethod extends Method {
  PredictableApacheRandomStringUtilsMethod() {
    this.getDeclaringType() instanceof ApacheRandomStringUtilsType
  }
}

private class PredictableApacheRandomStringUtilsMethodAccess extends PredictableRandomMethodAccess {
  PredictableApacheRandomStringUtilsMethodAccess() {
    this.getMethod() instanceof PredictableApacheRandomStringUtilsMethod and
    // The one valid use of this type that uses SecureRandom as a source of data.
    not (
      this.getMethod().getName() = "random" and
      not(
        // this.getArgument(6).getProperExpr().getType() instanceof TypeSecureRandom or
        isPredictableRandomRuntimeExp(this.getArgument(6).getProperExpr())
      )
    )
  }
}

private predicate isPredictableRandomRuntimeExp(VarAccess varAccess) {
  exists(StrictPredictableToAnyRandomConfig config |
    config.hasFlowTo(DataFlow::exprNode(varAccess))
  )
}

/**
 * Determines if this VarAccess can be safely assumed to be 'Secure'
 * at runtime due to the implied type of the variable due to assignments.
 */
private predicate isSecureRuntimeExpr(VarAccess varAccess) {
  /*
   * TODO: Perhaps also check for multiple constructors that assign different things.
   * This currently verifies that there is at least one final assignment that is 'Secure'.
   * This does not verify that this is the _exclusive_ assignment to this variable.
   *
   * In reality, we are trying to guess at what the type will be at runtime, which is a turning
   * complete problem, so we can only use this to eliminate the common cases.
   */

  exists(TypeSecureRandom typeSecureRandom | exprTypeFlow(varAccess, typeSecureRandom, false))
}

class PredictableJavaStdlibRandomMethodAcccess extends PredictableRandomMethodAccess {
  PredictableJavaStdlibRandomMethodAcccess() {
    this.getReceiverType() instanceof JavaStdlibInsecureRandomType and
    not isSecureRuntimeExpr(this.getQualifier())
  }
}

/**
 * A byte array tainted by insecure RNG.
 *
 * Examples:
 *
 * ```
 * byte[] array = new byte[];
 * new Random().nextBytes(array);
 * ```
 */
private class TaintedByteArrayWrite extends VarAccess {
  TaintedByteArrayWrite() {
    exists(PredictableJavaStdlibRandomMethodAcccess insecureMethodAccess, MethodAccess ma |
      ma.getMethod().hasName("nextBytes") and
      ma = insecureMethodAccess and
      ma.getArgument(0) = this
    )
  }
}

class SecureRandomMethodAccess extends MethodAccess {
  SecureRandomMethodAccess() { this.getReceiverType() instanceof TypeSecureRandom }
}

/**
 * Intermediate tracking step to find instances of RandomStringGenerator that are "safely" created.
 * A "safely" created RandomStringGenerator is defined as having used a SecureRandom method in the
 * RandomStringGenerator.Builder::usingRandom lambda.
 */
class SafeRandomStringGeneratorFlowConfig extends TaintTracking2::Configuration {
  SafeRandomStringGeneratorFlowConfig() { this = "RNG:SafeRandomStringGeneratorFlowConfig" }

  private predicate isUsingSafeUsingRandomSupplier(MethodAccess source) {
    exists(
      ApacheRandomStringGeneratorBuilderUsingRandomMethod usingRandomMethod,
      FunctionalExpr functionalExpr, SecureRandomMethodAccess secureRandomMethodAccess
    |
      usingRandomMethod = source.getMethod() and
      source.getArgument(0).getProperExpr() = functionalExpr and
      // Some SecureRandom method is used in the scope of the functional expression
      functionalExpr.asMethod() = secureRandomMethodAccess.getEnclosingCallable()
    )
  }

  override predicate isSource(DataFlow::Node src) { isUsingSafeUsingRandomSupplier(src.asExpr()) }

  /**
   * A sink is any RandomStringGenerator::generate method.
   */
  override predicate isSink(DataFlow::Node sink) {
    exists(ApacheRandomStringGeneratorType generatorType |
      sink.asExpr().(MethodAccess).getMethod() = generatorType.getGenerateMethod()
    )
  }

  private predicate isBuilderStep(MethodAccess previous, MethodAccess next) {
    exists(ApacheRandomStringGeneratorBuilderType builderType |
      builderType.getAMethod() = previous.getMethod() and
      previous = next.getQualifier()
    )
  }

  private predicate isGeneratorCallStep(Expr previous, MethodAccess next) {
    exists(ApacheRandomStringGeneratorType generatorType |
      generatorType.getGenerateMethod() = next.getMethod() and
      previous = next.getQualifier()
    )
  }

  override predicate isAdditionalTaintStep(DataFlow::Node previous, DataFlow::Node next) {
    isBuilderStep(previous.asExpr(), next.asExpr()) or
    isGeneratorCallStep(previous.asExpr(), next.asExpr())
  }
}

private class TaintedRandomStringGeneratorMethodAccess extends PredictableRandomMethodAccess {
  TaintedRandomStringGeneratorMethodAccess() {
    this.getMethod().getDeclaringType() instanceof ApacheRandomStringGeneratorType and
    not exists(SafeRandomStringGeneratorFlowConfig safeFlowSource |
      safeFlowSource.hasFlowTo(DataFlow::exprNode(this))
    )
  }
}

private class PredictableRandomTaintedMethodAccessSource extends PredictableRandomFlowSource {
  PredictableRandomTaintedMethodAccessSource() {
    this.asExpr() instanceof PredictableRandomMethodAccess // or
    // this.asExpr() instanceof TaintedByteArrayWrite
  }
}
