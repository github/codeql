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
  featureName = getASupportedFeatureName()
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
      name = param.asSource().asExpr().(Parameter).getName()
      or
      param.asSource().asExpr() instanceof DestructuringPattern and
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
string getASupportedFeatureName() {
  // allowlist of vetted features that are permitted in production
  result =
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
  TCalleeName() or
  TReceiverName() or
  TArgumentIndex() or
  TCalleeApiName() or
  TCalleeAccessPath() or
  TCalleeAccessPathWithStructuralInfo() or
  TEnclosingFunctionBody() or
  TFileImports() or
  TCalleeImports() or
  TCalleeFlexibleAccessPath() or
  TInputAccessPathFromCallee() or
  TInputArgumentIndex() or
  TContextFunctionInterfaces() or
  TContextSurroundingFunctionParameters()

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

  string toString() { result = this.getName() }
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
    result =
      strictconcat(DataFlow::CallNode call, string component |
        endpoint = call.getAnArgument() and component = call.getCalleeName()
      |
        component, " "
      )
  }
}

/**
 * The feature for the name of the receiver of the call, e.g. in a call `Artist.findOne(...)`, this is `Artist`.
 */
class ReceiverName extends EndpointFeature, TReceiverName {
  override string getName() { result = "receiverName" }

  override string getValue(DataFlow::Node endpoint) {
    result =
      strictconcat(DataFlow::CallNode call, string component |
        endpoint = call.getAnArgument() and
        component = call.getReceiver().asExpr().(VarRef).getName()
      |
        component, " "
      )
  }
}

/**
 * The feature for the argument index of the endpoint, e.g. in `f(a, endpoint, b)`, this is 1.
 */
class ArgumentIndex extends EndpointFeature, TArgumentIndex {
  override string getName() { result = "argumentIndex" }

  override string getValue(DataFlow::Node endpoint) {
    result =
      strictconcat(DataFlow::CallNode call, string component |
        endpoint = call.getAnArgument() and
        component = any(int argIndex | call.getArgument(argIndex) = endpoint).toString()
      |
        component, " "
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
    result =
      strictconcat(API::Node apiNode, string component |
        endpoint = apiNode.getInducingNode().(DataFlow::CallNode).getAnArgument() and
        AccessPaths::accessPaths(apiNode, false, _, component)
      |
        component, " "
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
 * The feature for the imports defined in the file containing an endpoint.
 *
 * ### Example
 *
 * ```javascript
 * import { findOne } from 'mongoose';
 * import * as _ from 'lodash';
 * const pg = require('pg');
 *
 * // ...
 * ```
 *
 * In this file, all endpoints will have the value `lodash mongoose pg` for the feature `fileImports`.
 */
class FileImports extends EndpointFeature, TFileImports {
  override string getName() { result = "fileImports" }

  override string getValue(DataFlow::Node endpoint) {
    result =
      concat(string importPath |
        importPath = SyntacticUtilities::getImportPathForFile(endpoint.getFile())
      |
        importPath, " " order by importPath
      )
  }
}

/**
 * The feature for the function parameters of the functions that enclose an endpoint.
 *
 * ### Example
 * ```javascript
 * function f(a, b) {
 *   // ...
 *   const g = (c, d) => x.foo(endpoint);
 * //                          ^^^^^^^^
 * }
 * ```
 * In the above example, the feature for the marked endpoint has value '(a, b)\n(c, d)'.
 */
class ContextSurroundingFunctionParameters extends EndpointFeature,
  TContextSurroundingFunctionParameters {
  override string getName() { result = "contextSurroundingFunctionParameters" }

  Function getRelevantFunction(DataFlow::Node endpoint) {
    result = endpoint.asExpr().getEnclosingFunction*()
  }

  override string getValue(DataFlow::Node endpoint) {
    result =
      concat(string functionParameterLine, Function f |
        f = getRelevantFunction(endpoint) and
        functionParameterLine = SyntacticUtilities::getFunctionParametersFeatureComponent(f)
      |
        functionParameterLine, "\n"
        order by
          f.getLocation().getStartLine(), f.getLocation().getStartColumn()
      )
  }
}

/**
 * The feature for the imports used in the callee of an invocation.
 *
 * ### Example
 *
 * ```javascript
 * import * as _ from 'lodash';
 *
 * // ...
 * _.deepClone(someObject);
 * //          ^^^^^^^^^^ will have the value `lodash` for the feature `calleeImports`.
 * ```
 */
class CalleeImports extends EndpointFeature, TCalleeImports {
  override string getName() { result = "calleeImports" }

  override string getValue(DataFlow::Node endpoint) {
    not result = SyntacticUtilities::getUnknownSymbol() and
    exists(DataFlow::InvokeNode invk |
      (
        invk.getAnArgument() = endpoint or
        SyntacticUtilities::getANestedInitializerValue(invk.getAnArgument()
              .asExpr()
              .getUnderlyingValue()).flow() = endpoint
      ) and
      result =
        concat(string importPath |
          importPath = SyntacticUtilities::getCalleeImportPath(invk.getCalleeNode())
        |
          importPath, " " order by importPath
        )
    )
  }
}

/**
 * The feature for the interfaces of all named functions in the same file as the endpoint.
 *
 * ### Example
 * ```javascript
 * // Will return: "f(a, b, c)\ng(x, y, z)\nh(u, v)" for this file.
 * function f(a, b, c) { ... }
 *
 * function g(x, y, z) {
 *   function h(u, v) { ... }
 *   ...
 * }
 * ```
 *
 * The feature value for the marked endpoint will be `f(a, b, c)\ng(x, y, z)\nh(u, v)`.
 */
class ContextFunctionInterfaces extends EndpointFeature, TContextFunctionInterfaces {
  override string getName() { result = "contextFunctionInterfaces" }

  override string getValue(DataFlow::Node endpoint) {
    result = SyntacticUtilities::getFunctionInterfacesForFile(endpoint.getFile())
  }
}

/**
 * Syntactic utilities for feature value computation.
 */
private module SyntacticUtilities {
  /** Gets an import located in `file`. */
  string getImportPathForFile(File file) {
    result = any(Import imp | imp.getFile() = file).getImportedPath().getValue()
  }

  /**
   * Gets the feature component for the parameters of a function.
   *
   * ```javascript
   * function f(a, b, c) { // will return "(a, b, c)" for this function
   *  return a + b + c;
   * }
   *
   * async function g(a) { // will return "(a)" for this function
   *   return 2*a
   * };
   *
   * const h = (b) => 3*b; // will return "(b)" for this function
   * ```
   */
  string getFunctionParametersFeatureComponent(Function f) {
    result =
      "(" +
        concat(string parameter, int i |
          parameter = getParameterNameOrUnknown(f.getParameter(i))
        |
          parameter, ", " order by i
        ) + ")"
  }

  /**
   * Gets the function interfaces of all named functions in a file, concatenated together.
   *
   * ```javascript
   * // Will return: "f(a, b, c)\ng(x, y, z)\nh(u, v)" for this file.
   * function f(a, b, c) { ... }
   *
   * function g(x, y, z) {
   *   function h(u, v) { ... }
   *   ...
   * }
   */
  string getFunctionInterfacesForFile(File file) {
    result =
      concat(Function func, string line |
        func.getFile() = file and
        exists(func.getName()) and
        line = func.getName() + getFunctionParametersFeatureComponent(func)
      |
        line, "\n" order by line
      )
  }

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
    else result = getSimplePropertyAccessPath(node)
  }

  /**
   * Computes a simple access path for how a user can refer to a value that appears in an (nested) object.
   *
   * Supports:
   * - properties of (nested) objects
   *
   * Unknown cases and property names results in `?`.
   */
  string getSimplePropertyAccessPath(DataFlow::Node node) {
    if exists(ObjectExpr o | o.getAProperty().getInit().getUnderlyingValue() = node.asExpr())
    then
      exists(DataFlow::PropWrite w |
        w.getRhs() = node and
        result = getSimpleParameterAccessPath(w.getBase()) + "." + getPropertyNameOrUnknown(w)
      )
    else result = getUnknownSymbol()
  }

  /**
   * Gets the imported package path that this node depends on, if any.
   *
   * Otherwise, returns '?'.
   *
   * XXX Be careful with using this in your features, as it might teach the model
   * a fixed list of "dangerous" libraries that could lead to bad generalization.
   */
  string getCalleeImportPath(DataFlow::Node node) {
    exists(DataFlow::Node src | src = node.getALocalSource() |
      if src instanceof DataFlow::ModuleImportNode
      then result = src.(DataFlow::ModuleImportNode).getPath()
      else
        if src instanceof DataFlow::PropRead
        then result = getCalleeImportPath(src.(DataFlow::PropRead).getBase())
        else
          if src instanceof DataFlow::InvokeNode
          then result = getCalleeImportPath(src.(DataFlow::InvokeNode).getCalleeNode())
          else
            if src.asExpr() instanceof AwaitExpr
            then result = getCalleeImportPath(src.asExpr().(AwaitExpr).getOperand().flow())
            else result = getUnknownSymbol()
    )
  }

  /**
   * Computes a simple access path for a node.
   *
   * Supports:
   * - variable reads (including `this` and `super`)
   * - imports
   * - await
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
            if e instanceof Import
            then result = "import(" + getSimpleImportPath(e) + ")"
            else
              if e instanceof AwaitExpr
              then result = "(await " + getSimpleAccessPath(e.(AwaitExpr).getOperand().flow()) + ")"
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
                  else result = getUnknownSymbol()
    )
  }

  string getUnknownSymbol() { result = "?" }

  /**
   * Gets the imported path.
   *
   * XXX To avoid teaching the ML model about npm packages, only relative paths are supported
   *
   * Unknown paths result in `?`.
   */
  string getSimpleImportPath(Import i) {
    if exists(i.getImportedPath().getValue())
    then
      exists(string p | p = i.getImportedPath().getValue() |
        if p.matches(".%") then result = "\"p\"" else result = "!" // hide absolute imports from the ML training
      )
    else result = getUnknownSymbol()
  }

  /**
   * Gets the property name of a property reference or `?` if it is unknown.
   */
  string getPropertyNameOrUnknown(DataFlow::PropRef ref) {
    if exists(ref.getPropertyName())
    then result = ref.getPropertyName()
    else result = getUnknownSymbol()
  }

  /**
   * Gets the parameter name if it exists, or `?` if it is unknown.
   */
  string getParameterNameOrUnknown(Parameter p) {
    if exists(p.getName()) then result = p.getName() else result = getUnknownSymbol()
  }
}

/**
 * The feature for the access path of the callee node of a call that has an argument that "contains" the endpoint.
 *
 * "Containment" is syntactic, and currently means that the endpoint is an argument to the call, or that the endpoint is a (nested) property value of an argument.
 *
 * This feature is intended as a superior version of the many `Callee*` features.
 *
 * Examples:
 * ```
 * foo(endpoint); // -> foo
 * foo.bar(endpoint); // -> foo.bar
 * foo.bar({ baz: endpoint }); // -> foo.bar
 * this.foo.bar(endpoint); // -> this.foo.bar
 * foo[complex()].bar(endpoint); // -> foo.?.bar
 * ```
 */
class CalleeFlexibleAccessPath extends EndpointFeature, TCalleeFlexibleAccessPath {
  override string getName() { result = "CalleeFlexibleAccessPath" }

  override string getValue(DataFlow::Node endpoint) {
    exists(DataFlow::InvokeNode invk |
      result = SyntacticUtilities::getSimpleAccessPath(invk.getCalleeNode()) and
      // ignore the unknown path
      not result = SyntacticUtilities::getUnknownSymbol() and
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
 * The feature for how a callee can refer to a the endpoint that is "contained" in some argument to a call
 *
 * "Containment" is syntactic, and currently means that the endpoint is an argument to the call, or that the endpoint is a (nested) property value of an argument.
 *
 * This feature, together with `InputArgumentIndex` is intended as a far superior version of the `ArgumentIndexFeature`.
 *
 * Examples:
 * ```
 * foo({ bar: endpoint }); // -> bar
 * foo(x, { bar: { baz: endpoint } }); // -> bar.baz
 * ```
 */
class InputAccessPathFromCallee extends EndpointFeature, TInputAccessPathFromCallee {
  override string getName() { result = "InputAccessPathFromCallee" }

  override string getValue(DataFlow::Node endpoint) {
    exists(DataFlow::InvokeNode invk |
      result = SyntacticUtilities::getSimpleParameterAccessPath(endpoint) and
      SyntacticUtilities::getANestedInitializerValue(invk.getAnArgument()
            .asExpr()
            .getUnderlyingValue()).flow() = endpoint
    )
  }
}

/**
 * The feature for how the index of an argument that "contains" and endpoint.
 *
 * "Containment" is syntactic, and currently means that the endpoint is an argument to the call, or that the endpoint is a (nested) property value of an argument.
 *
 * This feature is intended as a superior version of the `ArgumentIndexFeature`.
 *
 * Examples:
 * ```
 * foo(endpoint); // -> 0
 * foo({ bar: endpoint }); // -> 0
 * foo(x, { bar: { baz: endpoint } }); // -> 1
 * ```
 */
class InputArgumentIndex extends EndpointFeature, TInputArgumentIndex {
  override string getName() { result = "InputArgumentIndex" }

  override string getValue(DataFlow::Node endpoint) {
    exists(DataFlow::InvokeNode invk, DataFlow::Node arg, int i | arg = invk.getArgument(i) |
      result = i + "" and
      (
        invk.getAnArgument() = endpoint
        or
        SyntacticUtilities::getANestedInitializerValue(arg.asExpr().getUnderlyingValue()).flow() =
          endpoint
      )
    )
  }
}
