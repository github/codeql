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
  exists(EndPointFeature f | f.getEncoding() = featureName and result = f.getValue(endpoint))
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
string getASupportedFeatureName() { result = any(EndPointFeature f).getEncoding() }

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

private newtype TEndPointFeature =
  TEnclosingFunctionName() or
  TCalleeName() or
  TReceiverName() or
  TArgumentIndex() or
  TCalleeApiName() or
  TCalleeAccessPath() or
  TCalleeAccessPathWithStructuralInfo() or
  TEnclosingFunctionBody() or
  TCalleeAccessPathSimpleFromArgumentTraversal()

abstract class EndPointFeature extends TEndPointFeature {
  abstract string getEncoding();

  abstract string getValue(DataFlow::Node endpoint);

  string toString() { result = getEncoding() }
}

class EnclosingFunctionName extends EndPointFeature, TEnclosingFunctionName {
  override string getEncoding() { result = "enclosingFunctionName" }

  override string getValue(DataFlow::Node endpoint) {
    // The name of the function that encloses the endpoint.
    result =
      FunctionNames::getNameToFeaturize(FunctionBodyFeatures::getRepresentativeFunctionForEndpoint(endpoint))
  }
}

class CalleeName extends EndPointFeature, TCalleeName {
  override string getEncoding() { result = "calleeName" }

  override string getValue(DataFlow::Node endpoint) {
    // The name of the function being called, e.g. in a call `Artist.findOne(...)`, this is `findOne`.
    exists(DataFlow::CallNode call | endpoint = call.getAnArgument() |
      result = strictconcat(string component | component = call.getCalleeName() | component, " ")
    )
  }
}

class ReceiverName extends EndPointFeature, TReceiverName {
  override string getEncoding() { result = "receiverName" }

  override string getValue(DataFlow::Node endpoint) {
    // The name of the receiver of the call, e.g. in a call `Artist.findOne(...)`, this is `Artist`.
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

class ArgumentIndex extends EndPointFeature, TArgumentIndex {
  override string getEncoding() { result = "argumentIndex" }

  override string getValue(DataFlow::Node endpoint) {
    // The argument index of the endpoint, e.g. in `f(a, endpoint, b)`, this is 1.
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

class CalleeApiName extends EndPointFeature, TCalleeApiName {
  override string getEncoding() { result = "calleeApiName" }

  override string getValue(DataFlow::Node endpoint) {
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

class CalleeAccessPath extends EndPointFeature, TCalleeAccessPath {
  override string getEncoding() { result = "calleeAccessPath" }

  override string getValue(DataFlow::Node endpoint) {
    // The access path of the function being called, both without structural info, if the
    // function being called originates from an external API. For example, the endpoint here:
    //
    // ```js
    // const mongoose = require('mongoose'),
    //   User = mongoose.model('User', null);
    // User.findOne(ENDPOINT);
    // ```
    //
    // would have a callee access path without structural info of `mongoose model findOne`.
    result =
      concat(API::Node node, string accessPath |
        node.getInducingNode().(DataFlow::CallNode).getAnArgument() = endpoint and
        AccessPaths::accessPaths(node, false, accessPath, _)
      |
        accessPath, " "
      )
  }
}

class CalleeAccessPathWithStructuralInfo extends EndPointFeature,
  TCalleeAccessPathWithStructuralInfo {
  override string getEncoding() { result = "calleeAccessPathWithStructuralInfo" }

  override string getValue(DataFlow::Node endpoint) {
    // The access path of the function being called, both with structural info, if the
    // function being called originates from an external API. For example, the endpoint here:
    //
    // ```js
    // const mongoose = require('mongoose'),
    //   User = mongoose.model('User', null);
    // User.findOne(ENDPOINT);
    // ```
    //
    // would have a callee access path with structural info of
    // `mongoose member model instanceorreturn member findOne instanceorreturn`
    //
    // These features indicate that the callee comes from (reading the access path backwards) an
    // instance of the `findOne` member of an instance of the `model` member of the `mongoose`
    // external library.
    result =
      concat(API::Node node, string accessPath |
        node.getInducingNode().(DataFlow::CallNode).getAnArgument() = endpoint and
        AccessPaths::accessPaths(node, true, accessPath, _)
      |
        accessPath, " "
      )
  }
}

class EnclosingFunctionBody extends EndPointFeature, TEnclosingFunctionBody {
  override string getEncoding() { result = "enclosingFunctionBody" }

  override string getValue(DataFlow::Node endpoint) {
    // A feature containing natural language tokens from the function that encloses the endpoint in
    // the order that they appear in the source code.
    result =
      FunctionBodyFeatures::getBodyTokensFeature(FunctionBodyFeatures::getRepresentativeFunctionForEndpoint(endpoint))
  }
}

private module SyntacticUtilities {
  Expr getANestedProperty(ObjectExpr o) {
    exists(Expr init | init = o.getAProperty().getInit().getUnderlyingValue() |
      result = [init, getANestedProperty(init)]
    )
  }

  string getSimpleAccessPath(DataFlow::Node node) {
    if node.asExpr() instanceof SuperAccess
    then result = "super"
    else
      if node.asExpr() instanceof ThisAccess
      then result = "this"
      else
        if node.asExpr() instanceof VarAccess
        then result = node.asExpr().(VarAccess).getName()
        else
          if node instanceof DataFlow::PropRead
          then
            result =
              getSimpleAccessPath(node.(DataFlow::PropRead).getBase()) + "." +
                getPropertyNameOrUnknown(node)
          else
            if node instanceof DataFlow::InvokeNode
            then result = getSimpleAccessPath(node.(DataFlow::InvokeNode).getCalleeNode()) + "()"
            else result = "?"
  }
}

string getPropertyNameOrUnknown(DataFlow::PropRead read) {
  if exists(read.getPropertyName()) then result = read.getPropertyName() else result = "?"
}

class CalleeAccessPathSimpleFromArgumentTraversal extends EndPointFeature,
  TCalleeAccessPathSimpleFromArgumentTraversal {
  override string getEncoding() { result = "calleeAccessPathSimpleFromArgumentTraversal" }

  override string getValue(DataFlow::Node endpoint) {
    exists(DataFlow::InvokeNode invk |
      result = SyntacticUtilities::getSimpleAccessPath(invk.getCalleeNode()) and
      (
        invk.getAnArgument() = endpoint or
        SyntacticUtilities::getANestedProperty(invk.getAnArgument().asExpr().getUnderlyingValue())
            .flow() = endpoint
      )
    )
  }
}
