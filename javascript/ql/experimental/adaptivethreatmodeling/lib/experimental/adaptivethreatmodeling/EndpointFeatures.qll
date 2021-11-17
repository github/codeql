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
  // A feature containing natural language tokens from the neighborhood around the endpoint 
  (limited to within the function that encloses the endpoint), in
  // the order they appear in the source code. 
  exists(Raw::AstNode rootNode, DatabaseFeatures::AstNode rootNodeWrapped |
    featureName = "neighborhoodBody" and
    rootNode = NeighborhoodBodies::getNeighborhoodAstNode(Raw::astNode(endpoint.getAstNode())) and
    rootNodeWrapped = DatabaseFeatures::astNode(Wrapped::astNode(endpoint.getContainer(), rootNode)) and
    result =
      unique(string x |
        x = NeighborhoodBodies::getBodyTokenFeatureForNeighborhoodNode(rootNodeWrapped)
      )
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
        accessPath = AccessPaths::getAccessPath(node, includeStructuralInfo)
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
    result = getAnApiName(call)
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

/** This module provides functionality for getting the local neighborhood around an AST node within its enclosing function body, providing a locally-scoped version of the `enclosingFunctionBody` feature. */
module NeighborhoodBodies {
  /**
   * Return the ancestor of the input AST node that has the largest number of descendants (i.e. the node nearest the
   * root) but has no more than 128 descendants.
   * TODO: Maybe instead of a threshold on number of descendants, we should instead have a threshold on the number of
   * leaves in the subtree, which is a closer approximation to the number of tokens in the subtree.
   */
  Raw::AstNode getNeighborhoodAstNode(Raw::AstNode node) {
    if getNumDescendents(node.getParentNode()) > 128
    then result = node
    else result = getNeighborhoodAstNode(node.getParentNode())
  }

  /** Count number of descendants of an AST node */
  int getNumDescendents(Raw::AstNode node) { result = count(node.getAChildNode*()) }

  /**
   * Holds if `childNode` is an AST node under `rootNode` and `token` is a node attribute associated with `childNode`. Note that only AST leaves have node attributes.
   *
   * TODO we may need to restrict `rootNode` to be a neighborhood root to avoid a potentially big result set.
   */
  private predicate bodyTokens(
    DatabaseFeatures::AstNode rootNode, DatabaseFeatures::AstNode childNode, string token
  ) {
    childNode = rootNode.getAChild*() and
    token = unique(string t | DatabaseFeatures::nodeAttributes(childNode, t)) 
  }

  /**
   * Gets the body token feature limited to the part of the function body that lies under `rootNode` in the AST.
   *
   * This is a string of space-separated natural language tokens (AST leaves) in the order that they appear in the source code for the AST subtree rooted at `rootNode`. This is equivalent to the portion of the code that falls under
 * the AST subtree rooted at the given node, except that non-leaf nodes (such as operators) are excluded.
   */
  string getBodyTokenFeatureForNeighborhoodNode(DatabaseFeatures::AstNode rootNode) {
    // If a function has more than 256 body subtokens, then featurize it as absent. This
    // approximates the behavior of the classifer on non-generic body features where large body
    // features are replaced by the absent token.
    if count(DatabaseFeatures::AstNode node, string token | bodyTokens(rootNode, node, token)) > 256
    then result = ""
    else
      result =
        concat(int i, string rankedToken |
          rankedToken =
            rank[i](DatabaseFeatures::AstNode node, string token, Location l |
              bodyTokens(rootNode, node, token) and l = node.getLocation()
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
 * Returns a name of the API that a node originates from, if the node originates from an API.
 *
 * This predicate may have multiple results if the node corresponds to multiple nodes in the API graph forest.
 */
pragma[inline]
private string getAnApiName(DataFlow::Node node) {
  API::moduleImport(result).getASuccessor*().getInducingNode() = node
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
  string getAccessPath(API::Node node, Boolean includeStructuralInfo) {
    node = API::moduleImport(result)
    or
    exists(API::Node base, string baseName |
      base.getDepth() < node.getDepth() and baseName = getAccessPath(base, includeStructuralInfo)
    |
      // e.g. `new X`, `X()`
      node = [base.getInstance(), base.getReturn()] and
      if includeStructuralInfo = true
      then result = baseName + " instanceorreturn"
      else result = baseName
      or
      // e.g. `x.y`, `x[y]`, `const { y } = x`, where `y` is non-numeric and is known at analysis
      // time.
      exists(string member |
        node = base.getMember(member) and
        not node = base.getUnknownMember() and
        not isNumericString(member) and
        not (member = "default" and base = API::moduleImport(_)) and
        not member = "then" // use the 'promised' edges for .then callbacks
      |
        if includeStructuralInfo = true
        then result = baseName + " member " + member
        else result = baseName + " " + member
      )
      or
      // e.g. `x.y`, `x[y]`, `const { y } = x`, where `y` is numeric or not known at analysis time.
      (
        node = base.getUnknownMember() or
        node = base.getMember(any(string s | isNumericString(s)))
      ) and
      if includeStructuralInfo = true then result = baseName + " member" else result = baseName
      or
      // e.g. `x.then(y => ...)`
      node = base.getPromised() and
      result = baseName
      or
      // e.g. `x.y((a, b) => ...)`
      // Name callback parameters after their name in the source code.
      // For example, the `res` parameter in `express.get('/foo', (req, res) => {...})` will be
      // named `express member get functionalarg param res`.
      exists(string paramName |
        node = getNamedParameter(base.getAParameter(), paramName) and
        (
          if includeStructuralInfo = true
          then result = baseName + " functionalarg param " + paramName
          else result = baseName + " " + paramName
        )
        or
        exists(string callbackName, string index |
          node =
            getNamedParameter(base.getASuccessor("param " + index).getMember(callbackName),
              paramName) and
          index != "-1" and // ignore receiver
          if includeStructuralInfo = true
          then
            result =
              baseName + " functionalarg " + index + " " + callbackName + " param " + paramName
          else result = baseName + " " + index + " " + callbackName + " " + paramName
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
      "calleeAccessPath", "calleeAccessPathWithStructuralInfo", "enclosingFunctionBody",
      "neighborhoodBody"
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
