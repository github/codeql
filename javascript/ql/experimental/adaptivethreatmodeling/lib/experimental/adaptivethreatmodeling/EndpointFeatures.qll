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
  (
    // Features for endpoints that are contained within a function.
    exists(Function function |
      function = FunctionBodyFeatures::getRepresentativeFunctionForEndpoint(endpoint)
    |
      // The name of the function that encloses the endpoint.
      featureName = "enclosingFunctionName" and result = FunctionNames::getNameToFeaturize(function)
      or
      // A feature containing natural language tokens from the function that encloses the endpoint in
      // the order that they appear in the source code.
      featureName = "enclosingFunctionBody" and
      result = FunctionBodyFeatures::getBodyTokensFeature(function)
    )
    or
    result =
      strictconcat(DataFlow::CallNode call, string component |
        component = getACallBasedTokenFeatureComponent(endpoint, call, featureName)
      |
        component, " "
      )
    or
    // The access path of the function being called, both with and without structural info, if the
    // function being called originates from an external API. For example, the endpoint here:
    //
    // ```js
    // const mongoose = require('mongoose'),
    //   User = mongoose.model('User', null);
    // User.findOne(ENDPOINT);
    // ```
    //
    // would have a callee access path with structural info of
    // `mongoose member model instanceorreturn member findOne instanceorreturn`, and a callee access
    // path without structural info of `mongoose model findOne`.
    //
    // These features indicate that the callee comes from (reading the access path backwards) an
    // instance of the `findOne` member of an instance of the `model` member of the `mongoose`
    // external library.
    exists(AccessPaths::Boolean includeStructuralInfo |
      featureName =
        "calleeAccessPath" +
          any(string x | if includeStructuralInfo = true then x = "WithStructuralInfo" else x = "") and
      result =
        concat(API::Node node, string accessPath |
          node.getInducingNode().(DataFlow::CallNode).getAnArgument() = endpoint and
          AccessPaths::accessPaths(node, includeStructuralInfo, accessPath, _)
        |
          accessPath, " "
        )
    )
  )
}

/**
 * Gets a value of the function-call-related token-based feature named `featureName` associated
 * with the function call `call` and the endpoint `endpoint`.
 *
 * This may in general report multiple strings, each containing a space-separated list of tokens.
 *
 * **Technical details:** This predicate can have multiple values per endpoint and feature name. As
 * a result, the results from this predicate must be concatenated together.  However concatenating
 * other features like the function body tokens is expensive, so for performance reasons we separate
 * out this predicate from those other features.
 */
private string getACallBasedTokenFeatureComponent(
  DataFlow::Node endpoint, DataFlow::CallNode call, string featureName
) {
  // Performance optimization: Restrict feature extraction to endpoints we've explicitly asked to featurize.
  endpoint = any(FeaturizationConfig cfg).getAnEndpointToFeaturize() and
  // Features for endpoints that are an argument to a function call.
  endpoint = call.getAnArgument() and
  (
    // The name of the function being called, e.g. in a call `Artist.findOne(...)`, this is `findOne`.
    featureName = "calleeName" and result = call.getCalleeName()
    or
    // The name of the receiver of the call, e.g. in a call `Artist.findOne(...)`, this is `Artist`.
    featureName = "receiverName" and result = call.getReceiver().asExpr().(VarRef).getName()
    or
    // The argument index of the endpoint, e.g. in `f(a, endpoint, b)`, this is 1.
    featureName = "argumentIndex" and
    result = any(int argIndex | call.getArgument(argIndex) = endpoint).toString()
    or
    // The name of the API that the function being called originates from, if the function being
    // called originates from an external API. For example, the endpoint here:
    //
    // ```js
    // const mongoose = require('mongoose'),
    //   User = mongoose.model('User', null);
    // User.findOne(ENDPOINT);
    // ```
    //
    // would have a callee API name of `mongoose`.
    featureName = "calleeApiName" and
    exists(API::Node apiNode |
      AccessPaths::accessPaths(apiNode, false, _, result) and call = apiNode.getInducingNode()
    )
  )
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
    node = API::moduleImport(apiName) and accessPath = apiName
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
string getASupportedFeatureName() {
  result =
    [
      "enclosingFunctionName", "calleeName", "receiverName", "argumentIndex", "calleeApiName",
      "calleeAccessPath", "calleeAccessPathWithStructuralInfo", "enclosingFunctionBody"
    ]
}

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
