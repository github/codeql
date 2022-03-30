/*
 * For internal use only.
 *
 * Extracts data about the database for use in adaptive threat modeling (ATM).
 */

import javascript
private import FeaturizationConfig
private import FunctionBodyFeatures as FunctionBodyFeatures

/**
 * Gets the value of the token-based feature named `featureName` for the endpoint `endpoint`.
 *
 * This is a single string containing a space-separated list of tokens.
 */
private string getTokenFeature(DataFlow::Node endpoint, string featureName) {
  // Performance optimization: Restrict feature extraction to endpoints we've explicitly asked to featurize.
  endpoint = any(FeaturizationConfig cfg).getAnEndpointToFeaturize() and
  exists(EndpointFeature f | f.getName() = featureName and result = f.getValue(endpoint)) and
  isVettedFeature(featureName)
}

predicate isVettedFeature(string featureName) {
  // allowlist of vetted features that are permitted in production
  featureName =
    any(EndpointFeature f |
      f instanceof EnclosingFunctionName or
      f instanceof CalleeName or
      f instanceof ReceiverName or
      f instanceof ArgumentIndex or
      f instanceof CalleeApiName or
      f instanceof CalleeAccessPath or
      f instanceof CalleeAccessPathWithStructuralInfo or
      f instanceof EnclosingFunctionBody
    ).getName()
}

/**
 * This module provides functionality for getting a representation of the access path of nodes
 * within the program.
 *
 * For example, it gives the `User.find` callee here:
 *
 * ```js
 * const mongoose = require('mongoose'),
 * User = mongoose.model('User', null);
 * User.find({ 'isAdmin': true })
 * ```
 * the access path `mongoose member model instanceorreturn member find instanceorreturn`.
 *
 * This access path is based on the simplified access path that the untrusted data flowing to
 * external API query associates to each of its sinks, with modifications to optionally include
 * explicit structural information and to improve how well the path tokenizes.
 */
private module AccessPaths {
  bindingset[str]
  private predicate isNumericString(string str) { exists(str.toInt()) }

  /**
   * Gets a parameter of `base` with name `name`, or a property named `name` of a destructuring parameter.
   */
  private API::Node getNamedParameter(API::Node base, string name) {
    exists(API::Node param |
      param = base.getAParameter() and
      not param = base.getReceiver()
    |
      result = param and
      name = param.getAnImmediateUse().asExpr().(Parameter).getName()
      or
      param.getAnImmediateUse().asExpr() instanceof DestructuringPattern and
      result = param.getMember(name)
    )
  }

  /**
   * A utility class that is equivalent to `boolean` but does not require type joining.
   */
  class Boolean extends boolean {
    Boolean() { this = true or this = false }
  }

  /** Get the access path for the node. This includes structural information like `member`, `param`, and `functionalarg` if `includeStructuralInfo` is true. */
  predicate accessPaths(
    API::Node node, Boolean includeStructuralInfo, string accessPath, string apiName
  ) {
    //node = API::moduleImport(result)
    node = API::moduleImport(apiName) and
    accessPath = apiName
    or
    exists(API::Node previousNode, string previousAccessPath |
      previousNode.getDepth() < node.getDepth() and
      accessPaths(previousNode, includeStructuralInfo, previousAccessPath, apiName)
    |
      // e.g. `new X`, `X()`
      node = [previousNode.getInstance(), previousNode.getReturn()] and
      if includeStructuralInfo = true
      then accessPath = previousAccessPath + " instanceorreturn"
      else accessPath = previousAccessPath
      or
      // e.g. `x.y`, `x[y]`, `const { y } = x`, where `y` is non-numeric and is known at analysis
      // time.
      exists(string member |
        node = previousNode.getMember(member) and
        not node = previousNode.getUnknownMember() and
        not isNumericString(member) and
        not (member = "default" and previousNode = API::moduleImport(_)) and
        not member = "then" // use the 'promised' edges for .then callbacks
      |
        if includeStructuralInfo = true
        then accessPath = previousAccessPath + " member " + member
        else accessPath = previousAccessPath + " " + member
      )
      or
      // e.g. `x.y`, `x[y]`, `const { y } = x`, where `y` is numeric or not known at analysis time.
      (
        node = previousNode.getUnknownMember() or
        node = previousNode.getMember(any(string s | isNumericString(s)))
      ) and
      if includeStructuralInfo = true
      then accessPath = previousAccessPath + " member"
      else accessPath = previousAccessPath
      or
      // e.g. `x.then(y => ...)`
      node = previousNode.getPromised() and
      accessPath = previousAccessPath
      or
      // e.g. `x.y((a, b) => ...)`
      // Name callback parameters after their name in the source code.
      // For example, the `res` parameter in `express.get('/foo', (req, res) => {...})` will be
      // named `express member get functionalarg param res`.
      exists(string paramName |
        node = getNamedParameter(previousNode.getAParameter(), paramName) and
        (
          if includeStructuralInfo = true
          then accessPath = previousAccessPath + " functionalarg param " + paramName
          else accessPath = previousAccessPath + " " + paramName
        )
        or
        exists(string callbackName, int index |
          node =
            getNamedParameter(previousNode
                  .getASuccessor(API::Label::parameter(index))
                  .getMember(callbackName), paramName) and
          index != -1 and // ignore receiver
          if includeStructuralInfo = true
          then
            accessPath =
              previousAccessPath + " functionalarg " + index + " " + callbackName + " param " +
                paramName
          else accessPath = previousAccessPath + " " + index + " " + callbackName + " " + paramName
        )
      )
    )
  }
}

private module FunctionNames {
  /**
   * Get the name of the function.
   *
   * We attempt to assign unnamed entities approximate names if they are passed to a likely
   * external library function. If we can't assign them an approximate name, we give them the name
   * `""`, so that these entities are included in `AdaptiveThreatModeling.qll`.
   *
   * For entities which have multiple names, we choose the lexically smallest name.
   */
  string getNameToFeaturize(Function function) {
    if exists(function.getName())
    then result = min(function.getName())
    else
      if exists(getApproximateNameForFunction(function))
      then result = getApproximateNameForFunction(function)
      else result = ""
  }

  /**
   * Holds if the call `call` has `function` is its `argumentIndex`th argument.
   */
  private predicate functionUsedAsArgumentToCall(
    Function function, DataFlow::CallNode call, int argumentIndex
  ) {
    DataFlow::localFlowStep*(call.getArgument(argumentIndex), function.flow())
  }

  /**
   * Returns a generated name for the function. This name is generated such that
   * entities with the same names have similar behavior.
   */
  private string getApproximateNameForFunction(Function function) {
    count(DataFlow::CallNode call, int index | functionUsedAsArgumentToCall(function, call, index)) =
      1 and
    exists(DataFlow::CallNode call, int index, string basePart |
      functionUsedAsArgumentToCall(function, call, index) and
      (
        if count(getReceiverName(call)) = 1
        then basePart = getReceiverName(call) + "."
        else basePart = ""
      ) and
      result = basePart + call.getCalleeName() + "#functionalargument"
    )
  }

  private string getReceiverName(DataFlow::CallNode call) {
    result = call.getReceiver().asExpr().(VarAccess).getName()
  }
}

/** Get a name of a supported generic token-based feature. */
string getASupportedFeatureName() { isVettedFeature(result) }

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
 * See EndpointFeauture
 */
private newtype TEndpointFeature =
  TEnclosingFunctionName() or
  TCalleeName() or
  TReceiverName() or
  TArgumentIndex() or
  TCalleeApiName() or
  TCalleeAccessPath() or
  TCalleeAccessPathWithStructuralInfo() or
  TEnclosingFunctionBody() or
  TCalleeAccessPathSimpleFromArgumentTraversal() or
  TParameterAccessPathSimpleFromArgumentTraversal()

/**
 * An implementation of an endpoint feature: produces feature names and values for used in ML.
 */
abstract class EndpointFeature extends TEndpointFeature {
  /**
   * Gets the name of the feature. Used by the ML model.
   * Changes to the name of a feature requires training the model again.
   */
  abstract string getName();

  /**
   * Gets the value of the feature. Used by the ML model.
   * Changes to the value of a feature requires training the model again.
   */
  abstract string getValue(DataFlow::Node endpoint);

  string toString() { result = getName() }
}

/**
 * The feature for the name of the function that encloses the endpoint.
 */
class EnclosingFunctionName extends EndpointFeature, TEnclosingFunctionName {
  override string getName() { result = "enclosingFunctionName" }

  override string getValue(DataFlow::Node endpoint) {
    result =
      FunctionNames::getNameToFeaturize(FunctionBodyFeatures::getRepresentativeFunctionForEndpoint(endpoint))
  }
}

/**
 * The feature for the name of the function being called, e.g. in a call `Artist.findOne(...)`, this is `findOne`.
 */
class CalleeName extends EndpointFeature, TCalleeName {
  override string getName() { result = "calleeName" }

  override string getValue(DataFlow::Node endpoint) {
    exists(DataFlow::CallNode call | endpoint = call.getAnArgument() |
      result = strictconcat(string component | component = call.getCalleeName() | component, " ")
    )
  }
}

/**
 * The feature for the name of the receiver of the call, e.g. in a call `Artist.findOne(...)`, this is `Artist`.
 */
class ReceiverName extends EndpointFeature, TReceiverName {
  override string getName() { result = "receiverName" }

  override string getValue(DataFlow::Node endpoint) {
    exists(DataFlow::CallNode call | endpoint = call.getAnArgument() |
      result =
        strictconcat(string component |
          component = call.getReceiver().asExpr().(VarRef).getName()
        |
          component, " "
        )
    )
  }
}

/**
 * The feature for the argument index of the endpoint, e.g. in `f(a, endpoint, b)`, this is 1.
 */
class ArgumentIndex extends EndpointFeature, TArgumentIndex {
  override string getName() { result = "argumentIndex" }

  override string getValue(DataFlow::Node endpoint) {
    exists(DataFlow::CallNode call | endpoint = call.getAnArgument() |
      result =
        strictconcat(string component |
          component = any(int argIndex | call.getArgument(argIndex) = endpoint).toString()
        |
          component, " "
        )
    )
  }
}

/**
 * The feature for the name of the API that the function being called originates from, if the function being
 * called originates from an external API. For example, the endpoint here:
 *
 * ```js
 * const mongoose = require('mongoose'),
 *   User = mongoose.model('User', null);
 * User.findOne(ENDPOINT);
 * ```
 */
class CalleeApiName extends EndpointFeature, TCalleeApiName {
  override string getName() { result = "calleeApiName" }

  override string getValue(DataFlow::Node endpoint) {
    exists(API::Node apiNode |
      endpoint = apiNode.getInducingNode().(DataFlow::CallNode).getAnArgument()
    |
      result =
        strictconcat(string component |
          AccessPaths::accessPaths(apiNode, false, _, component)
        |
          component, " "
        )
    )
  }
}

/**
 * The access path of the function being called, both without structural info, if the
 * function being called originates from an external API. For example, the endpoint here:
 *
 * ```js
 * const mongoose = require('mongoose'),
 *   User = mongoose.model('User', null);
 * User.findOne(ENDPOINT);
 * ```
 *
 * would have a callee access path without structural info of `mongoose model findOne`.
 */
class CalleeAccessPath extends EndpointFeature, TCalleeAccessPath {
  override string getName() { result = "calleeAccessPath" }

  override string getValue(DataFlow::Node endpoint) {
    result =
      concat(API::Node node, string accessPath |
        node.getInducingNode().(DataFlow::CallNode).getAnArgument() = endpoint and
        AccessPaths::accessPaths(node, false, accessPath, _)
      |
        accessPath, " "
      )
  }
}

/**
 * The access path of the function being called, both with structural info, if the
 * function being called originates from an external API. For example, the endpoint here:
 *
 * ```js
 * const mongoose = require('mongoose'),
 *   User = mongoose.model('User', null);
 * User.findOne(ENDPOINT);
 * ```
 *
 * would have a callee access path with structural info of
 * `mongoose member model instanceorreturn member findOne instanceorreturn`
 *
 * These features indicate that the callee comes from (reading the access path backwards) an
 * instance of the `findOne` member of an instance of the `model` member of the `mongoose`
 * external library.
 */
class CalleeAccessPathWithStructuralInfo extends EndpointFeature,
  TCalleeAccessPathWithStructuralInfo {
  override string getName() { result = "calleeAccessPathWithStructuralInfo" }

  override string getValue(DataFlow::Node endpoint) {
    result =
      concat(API::Node node, string accessPath |
        node.getInducingNode().(DataFlow::CallNode).getAnArgument() = endpoint and
        AccessPaths::accessPaths(node, true, accessPath, _)
      |
        accessPath, " "
      )
  }
}

/**
 * The feature for the natural language tokens from the function that encloses the endpoint in
 *    the order that they appear in the source code.
 */
class EnclosingFunctionBody extends EndpointFeature, TEnclosingFunctionBody {
  override string getName() { result = "enclosingFunctionBody" }

  override string getValue(DataFlow::Node endpoint) {
    result =
      FunctionBodyFeatures::getBodyTokensFeature(FunctionBodyFeatures::getRepresentativeFunctionForEndpoint(endpoint))
  }
}

/**
 * Syntactic utilities for feature value computation.
 */
private module SyntacticUtilities {
  /**
   * Gets a property initializer value in a an object literal or one of its nested object literals.
   */
  Expr getANestedInitializerValue(ObjectExpr o) {
    exists(Expr init | init = o.getAProperty().getInit().getUnderlyingValue() |
      result = [init, getANestedInitializerValue(init)]
    )
  }

  /**
   * Computes a simple access path for how a callee can refer to a value that appears in an argument to a call.
   *
   * Supports:
   * - direct arguments
   * - properties of (nested) objects that are arguments
   *
   * Unknown cases and property names results in `?`.
   */
  string getSimpleParameterAccessPath(DataFlow::Node node) {
    if exists(DataFlow::CallNode call | node = call.getArgument(_))
    then exists(DataFlow::CallNode call, int i | node = call.getArgument(i) | result = i + "")
    else
      if exists(ObjectExpr o | o.getAProperty().getInit().getUnderlyingValue() = node.asExpr())
      then
        exists(DataFlow::PropWrite w |
          w.getRhs() = node and
          result = getSimpleParameterAccessPath(w.getBase()) + "." + getPropertyNameOrUnknown(w)
        )
      else result = "?"
  }

  /**
   * Computes a simple access path for a node.
   *
   * Supports:
   * - variable reads (including `this` and `super`)
   * - property reads
   * - invocations
   *
   * Unknown cases and property names results in `?`.
   */
  string getSimpleAccessPath(DataFlow::Node node) {
    exists(Expr e | e = node.asExpr().getUnderlyingValue() |
      if e instanceof SuperAccess
      then result = "super"
      else
        if e instanceof ThisAccess
        then result = "this"
        else
          if e instanceof VarAccess
          then result = e.(VarAccess).getName()
          else
            if e instanceof AwaitExpr
            then result = getSimpleAccessPath(e.(AwaitExpr).getOperand().flow()) + ".then()"
            else
              if node instanceof DataFlow::PropRead
              then
                result =
                  getSimpleAccessPath(node.(DataFlow::PropRead).getBase()) + "." +
                    getPropertyNameOrUnknown(node)
              else
                if node instanceof DataFlow::InvokeNode
                then
                  result = getSimpleAccessPath(node.(DataFlow::InvokeNode).getCalleeNode()) + "()"
                else result = "?"
    )
  }
}

/**
 * Gets the property name of a property reference or `?` if it is unknown.
 */
string getPropertyNameOrUnknown(DataFlow::PropRef ref) {
  if exists(ref.getPropertyName()) then result = ref.getPropertyName() else result = "?"
}

/**
 * The feature for the access path of the callee node of a call that has an argument that "contains" the endpoint.
 *
 * "Containment" is syntactic, and currently means that the endpoint is an argument to the call, or that the endpoint is a (nested) property value of an argument.
 *
 * This feature is intended as a superior version of the many `Callee*` features.
 */
class CalleeAccessPathSimpleFromArgumentTraversal extends EndpointFeature,
  TCalleeAccessPathSimpleFromArgumentTraversal {
  override string getName() { result = "calleeAccessPathSimpleFromArgumentTraversal" }

  override string getValue(DataFlow::Node endpoint) {
    exists(DataFlow::InvokeNode invk |
      exists(string path |
        path = SyntacticUtilities::getSimpleAccessPath(invk.getCalleeNode()) and
        // collapse the unknown path to the empty string, as is convention for old features
        if path = "?" then result = "" else result = path
      ) and
      (
        invk.getAnArgument() = endpoint or
        SyntacticUtilities::getANestedInitializerValue(invk.getAnArgument()
              .asExpr()
              .getUnderlyingValue()).flow() = endpoint
      )
    )
  }
}

/**
 * The feature for how a callee can refer to a the endpoint that is "contained" in an argument to a call
 *
 * "Containment" is syntactic, and currently means that the endpoint is an argument to the call, or that the endpoint is a (nested) property value of an argument.
 *
 * This feature is intended as a superior version of the `ArgumentIndexFeature`.
 */
class ParameterAccessPathSimpleFromArgumentTraversal extends EndpointFeature,
  TParameterAccessPathSimpleFromArgumentTraversal {
  override string getName() { result = "ParameterAccessPathSimpleFromArgumentTraversal" }

  override string getValue(DataFlow::Node endpoint) {
    exists(DataFlow::InvokeNode invk |
      result = SyntacticUtilities::getSimpleParameterAccessPath(endpoint) and
      (
        invk.getAnArgument() = endpoint or
        SyntacticUtilities::getANestedInitializerValue(invk.getAnArgument()
              .asExpr()
              .getUnderlyingValue()).flow() = endpoint
      )
    )
  }
}
