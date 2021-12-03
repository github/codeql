/*
 * For internal use only.
 *
 * Extracts data about the database for use in adaptive threat modeling (ATM).
 */

import javascript
import CodeToFeatures
import EndpointScoring

/**
 * Gets the value of the token-based feature named `featureName` for the endpoint `endpoint`.
 *
 * This is a single string containing a space-separated list of tokens.
 */
private string getTokenFeature(DataFlow::Node endpoint, string featureName) {
  // Features for endpoints that are contained within a function.
  exists(DatabaseFeatures::Entity entity | entity = getRepresentativeEntityForEndpoint(endpoint) |
    // The name of the function that encloses the endpoint.
    featureName = "enclosingFunctionName" and result = entity.getName()
    or
    // A feature containing natural language tokens from the function that encloses the endpoint in
    // the order that they appear in the source code.
    featureName = "enclosingFunctionBody" and
    result = unique(string x | x = FunctionBodies::getBodyTokenFeatureForEntity(entity))
  )
  or
  exists(getACallBasedTokenFeatureComponent(endpoint, _, featureName)) and
  result =
    concat(DataFlow::CallNode call, string component |
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
}

/**
 * Gets a value of the function-call-related token-based feature named `featureName` associated
 * with the function call `call` and the endpoint `endpoint`.
 *
 * This may in general report multiple strings, each containing a space-separated list of tokens.
 *
 * **Technical details:** This predicate can have multiple values per endpoint and feature name.  As a
 * result, the results from this predicate must be concatenated together.  However concatenating
 * other features like the function body tokens is expensive, so we separate out this predicate
 * from others like `FunctionBodies::getBodyTokenFeatureForEntity` to avoid having to perform this
 * concatenation operation on other features like the function body tokens.
 */
private string getACallBasedTokenFeatureComponent(
  DataFlow::Node endpoint, DataFlow::CallNode call, string featureName
) {
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

/** This module provides functionality for getting the function body feature associated with a particular entity. */
module FunctionBodies {
  /** Holds if `node` is an AST node within the entity `entity` and `token` is a node attribute associated with `node`. */
  private predicate bodyTokens(
    DatabaseFeatures::Entity entity, DatabaseFeatures::AstNode node, string token
  ) {
    DatabaseFeatures::astNodes(entity, _, _, node, _) and
    token = unique(string t | DatabaseFeatures::nodeAttributes(node, t))
  }

  /**
   * Gets the body token feature for the specified entity.
   *
   * This is a string containing natural language tokens in the order that they appear in the source code for the entity.
   */
  string getBodyTokenFeatureForEntity(DatabaseFeatures::Entity entity) {
    // If a function has more than 256 body subtokens, then featurize it as absent. This
    // approximates the behavior of the classifer on non-generic body features where large body
    // features are replaced by the absent token.
    if count(DatabaseFeatures::AstNode node, string token | bodyTokens(entity, node, token)) > 256
    then result = ""
    else
      result =
        concat(int i, string rankedToken |
          rankedToken =
            rank[i](DatabaseFeatures::AstNode node, string token, Location l |
              bodyTokens(entity, node, token) and l = node.getLocation()
            |
              token
              order by
                l.getFile().getAbsolutePath(), l.getStartLine(), l.getStartColumn(), l.getEndLine(),
                l.getEndColumn(), token
            )
        |
          rankedToken, " " order by i
        )
  }
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

/** Get a name of a supported generic token-based feature. */
private string getASupportedFeatureName() {
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
  featureName = getASupportedFeatureName() and
  (
    featureValue = unique(string x | x = getTokenFeature(endpoint, featureName))
    or
    not exists(unique(string x | x = getTokenFeature(endpoint, featureName))) and featureValue = ""
  )
}
