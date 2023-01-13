/**
 * For internal use only.
 *
 * Extracts data about the database for use in adaptive threat modeling (ATM).
 */

private import java
private import semmle.code.java.dataflow.DataFlow::DataFlow as DataFlow
private import FeaturizationConfig

/**
 * Gets the value of the token-based feature named `featureName` for the endpoint `endpoint`.
 *
 * This is a single string containing a space-separated list of tokens.
 */
private string getTokenFeature(DataFlow::Node endpoint, string featureName) {
  // Performance optimization: Restrict feature extraction to endpoints we've explicitly asked to featurize.
  endpoint = any(FeaturizationConfig cfg).getAnEndpointToFeaturize() and
  exists(EndpointFeature f | f.getName() = featureName and result = f.getValue(endpoint)) and
  featureName = getASupportedFeatureName()
}

/** Get a name of a supported generic token-based feature. */
string getASupportedFeatureName() { result = any(EndpointFeature f).getName() }

/**
 * Generic token-based features for ATM.
 *
 * This predicate holds if the generic token-based feature named `featureName` has the value
 * `featureValue` for the endpoint `endpoint`.
 */
predicate tokenFeatures(DataFlow::Node endpoint, string featureName, string featureValue) {
  // Performance optimization: Restrict feature extraction to endpoints we've explicitly asked to featurize.
  endpoint = any(FeaturizationConfig cfg).getAnEndpointToFeaturize() and
  featureValue = getTokenFeature(endpoint, featureName)
}

/**
 * See EndpointFeature
 */
private newtype TEndpointFeature =
  TEnclosingFunctionName() or
  TInputArgumentIndex() or
  TCalleeFlexibleAccessPath() or
  TEnclosingFunctionSignature() or
  TContextFunctionInterfaces()

/**
 * An implementation of an endpoint feature: defines feature-name/value tuples for use in ML.
 */
abstract class EndpointFeature extends TEndpointFeature {
  /**
   * Gets the name of the feature. Used by the ML model.
   * Names are coupled to models: changing the name of a feature requires retraining the model.
   */
  abstract string getName();

  /**
   * Gets the value of the feature. Used by the ML model.
   * Models are trained based on feature values, so changing the value of a feature requires retraining the model.
   */
  abstract string getValue(DataFlow::Node endpoint);

  string toString() { result = this.getName() }
}

//----------------------------------------------------------------------------------------------------------------------
// Feature: EnclosingFunctionName
//----------------------------------------------------------------------------------------------------------------------
/**
 * The feature for the name of the function that encloses the endpoint.
 */
class EnclosingFunctionName extends EndpointFeature, TEnclosingFunctionName {
  override string getName() { result = "enclosingFunctionName" }

  override string getValue(DataFlow::Node endpoint) {
    result = endpoint.getEnclosingCallable().getName()
  }
}

//----------------------------------------------------------------------------------------------------------------------
// Feature: InputArgumentIndex
//----------------------------------------------------------------------------------------------------------------------
class InputArgumentIndex extends EndpointFeature, TInputArgumentIndex {
  override string getName() { result = "InputArgumentIndex" }

  override string getValue(DataFlow::Node endpoint) {
    exists(Argument arg | endpoint.asExpr() = arg and result = arg.getPosition().toString())
  }
}

//----------------------------------------------------------------------------------------------------------------------
// Feature: CalleeFlexibleAccessPath
//----------------------------------------------------------------------------------------------------------------------
class CalleeFlexibleAccessPath extends EndpointFeature, TCalleeFlexibleAccessPath {
  override string getName() { result = "CalleeFlexibleAccessPath" }

  override string getValue(DataFlow::Node endpoint) {
    exists(Callable callee, Call call, string package, string type, string name |
      endpoint.asExpr() = call.getAnArgument() and
      callee = call.getCallee() and
      package = callee.getDeclaringType().getPackage().getName() and
      type = callee.getDeclaringType().getName() and //TODO: Will this work for inner classes? Will it produce X$Y? What about lambdas? What about enums? What about interfaces? What about annotations?
      name = callee.getName() and
      result = package + "." + type + "." + name
    )
  }
}

//----------------------------------------------------------------------------------------------------------------------
// Feature: EnclosingFunctionSignature
//----------------------------------------------------------------------------------------------------------------------
class EnclosingFunctionSignature extends EndpointFeature, TEnclosingFunctionSignature {
  override string getName() { result = "enclosingFunctionSignature" }

  override string getValue(DataFlow::Node endpoint) {
    exists(Callable callee |
      callee = endpoint.getEnclosingCallable() and
      result = callee.paramsString()
    )
  }
}

//----------------------------------------------------------------------------------------------------------------------
// Feature: ContextFunctionInterfaces
//----------------------------------------------------------------------------------------------------------------------
class ContextFunctionInterfaces extends EndpointFeature, TContextFunctionInterfaces {
  override string getName() { result = "contextFunctionInterfaces" }

  override string getValue(DataFlow::Node endpoint) {
    result =
      concat(Method method, string line |
        method.getLocation().getFile() = endpoint.getLocation().getFile() and
        line = method.getStringSignature()
      |
        line, "\n" order by line
      )
  }
}
