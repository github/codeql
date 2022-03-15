/*
 * FunctionBodyFeatures.qll
 *
 * Contains logic relating to the `enclosingFunctionBody` and `enclosingFunctionName` features.
 */

import javascript
private import FeaturizationConfig

/**
 * Gets a tokenized representation of the AST node for use in the `enclosingFunctionBody` feature.
 */
string getTokenizedAstNode(AstNode node) {
  // e.g. `x` -> "x"
  result = node.(Identifier).getName()
  or
  // Computed property accesses for which we can predetermine the property being accessed.
  // e.g. we'll featurize the `["date"]` part of `response["date"]` as `date`
  result = node.(IndexExpr).getPropertyName()
  or
  // We use `getRawValue` to give us distinct representations for `0xa`, `0xA`, and `10`.
  // e.g. `0xa` -> "0xa", `0xA` -> "0xA", `10` -> "10"
  result = node.(NumberLiteral).getRawValue()
  or
  // We use `getValue` rather than `getRawValue` so we assign `"a"` and `'a'` the same
  // representation.
  // e.g. `"a"` -> "a", `'a'` -> "a", `true` -> "true"
  not node instanceof NumberLiteral and
  result = node.(Literal).getValue()
  or
  // e.g. we'll featurize the `Hello ` and `!` parts of ``Hello ${user.name}!`` to "Hello " and "!"
  // respectively
  result = node.(TemplateElement).getRawValue()
}

/** Gets an AST node within the function `f` that we should featurize. */
pragma[inline]
AstNode getAnAstNodeToFeaturize(Function f) {
  result.getParent*() = f and
  // Don't featurize the function name as part of the function body tokens
  not result = f.getIdentifier()
}

/** DEPRECATED: Alias for getAnAstNodeToFeaturize */
deprecated ASTNode getAnASTNodeToFeaturize(Function f) { result = getAnAstNodeToFeaturize(f) }

/**
 * Gets a function that contains the endpoint.
 *
 * This can have multiple results, since functions can be nested in JavaScript. The predicate
 * `getRepresentativeFunctionForEndpoint` selects a single result from this predicate to use to
 * construct the `enclosingFunctionBody` feature for that endpoint. Generally you will want to use
 * `getRepresentativeFunctionForEndpoint` instead of this predicate.
 */
private Function getAFunctionForEndpoint(DataFlow::Node endpoint) {
  // Performance optimization: Restrict the set of endpoints to the endpoints to featurize.
  endpoint = any(FeaturizationConfig cfg).getAnEndpointToFeaturize() and
  result = endpoint.getContainer().getEnclosingContainer*()
}

/**
 * The maximum number of AST nodes an function containing an endpoint should have before we should
 * choose a smaller function to represent the endpoint.
 *
 * This is intended to represent a balance in terms of the amount of context we provide to the
 * model: we don't want the function to be too small, because then it doesn't contain very much
 * context and miss useful information, but also we don't want it to be too large, because then
 * there's likely to be a lot of irrelevant or very loosely related context.
 */
private int getMaxNumAstNodes() { result = 1024 }

/**
 * Returns the number of AST nodes contained within the specified function.
 */
private int getNumAstNodesInFunction(Function function) {
  // Restrict the values `function` can take on
  function = getAFunctionForEndpoint(_) and
  result = count(getAnAstNodeToFeaturize(function))
}

/**
 * Get the enclosing function for an endpoint.
 *
 * This is used to compute the `enclosingFunctionBody` and `enclosingFunctionName` features.
 *
 * We try to use the largest function containing the endpoint that's below the AST node limit
 * defined in `getMaxNumAstNodes`. In the event of a tie, we use the function that appears first
 * within the source code.
 *
 * If no functions are smaller than the AST node limit, then we use the smallest function containing
 * the endpoint.
 */
Function getRepresentativeFunctionForEndpoint(DataFlow::Node endpoint) {
  // Check whether there's a function containing the endpoint that's smaller than the AST node
  // limit.
  if getNumAstNodesInFunction(getAFunctionForEndpoint(endpoint)) <= getMaxNumAstNodes()
  then
    // Use the largest function smaller than the AST node limit, resolving ties using the function
    // that appears first in the source code.
    result =
      min(Function function, int numAstNodes, Location l |
        function = getAFunctionForEndpoint(endpoint) and
        numAstNodes = getNumAstNodesInFunction(function) and
        numAstNodes <= getMaxNumAstNodes() and
        l = function.getLocation()
      |
        function
        order by
          numAstNodes desc, l.getStartLine(), l.getStartColumn(), l.getEndLine(), l.getEndColumn()
      )
  else
    // Use the smallest function, resolving ties using the function that appears first in the source
    // code.
    result =
      min(Function function, int numAstNodes, Location l |
        function = getAFunctionForEndpoint(endpoint) and
        numAstNodes = getNumAstNodesInFunction(function) and
        l = function.getLocation()
      |
        function
        order by
          numAstNodes, l.getStartLine(), l.getStartColumn(), l.getEndLine(), l.getEndColumn()
      )
}

/** Returns an AST node within the function `f` that an associated token feature. */
AstNode getAnAstNodeWithAFeature(Function f) {
  // Performance optimization: Restrict the set of functions to those containing an endpoint to featurize.
  f = getRepresentativeFunctionForEndpoint(any(FeaturizationConfig cfg).getAnEndpointToFeaturize()) and
  result = getAnAstNodeToFeaturize(f)
}

/** DEPRECATED: Alias for getAnAstNodeWithAFeature */
deprecated ASTNode getAnASTNodeWithAFeature(Function f) { result = getAnAstNodeWithAFeature(f) }

/** Returns the number of source-code characters in a function. */
int getNumCharsInFunction(Function f) {
  result =
    strictsum(AstNode node | node = getAnAstNodeWithAFeature(f) | getTokenizedAstNode(node).length())
}

/**
 * Gets the maximum number of characters a feature can be.
 * The evaluator string limit is 5395415 characters. We choose a limit lower than this.
 */
private int getMaxChars() { result = 1000000 }

/**
 * Returns a featurized representation of the function that can be used to populate the
 * `enclosingFunctionBody` feature for an endpoint.
 */
string getBodyTokensFeature(Function function) {
  // Performance optimization: If a function has more than 256 body subtokens, then featurize it as
  // absent. This approximates the behavior of the classifer on non-generic body features where
  // large body features are replaced by the absent token.
  //
  // We count nodes instead of tokens because tokens are often not unique.
  strictcount(AstNode node |
    node = getAnAstNodeToFeaturize(function) and
    exists(getTokenizedAstNode(node))
  ) <= 256 and
  // Performance optimization: If a function has more than getMaxChars() characters in its body subtokens,
  // then featurize it as absent.
  getNumCharsInFunction(function) <= getMaxChars() and
  result =
    strictconcat(Location l, string token |
      // The use of a nested exists here allows us to avoid duplicates due to two AST nodes in the
      // same location featurizing to the same token. By using a nested exists, we take only unique
      // (location, token) pairs.
      exists(AstNode node |
        node = getAnAstNodeToFeaturize(function) and
        token = getTokenizedAstNode(node) and
        l = node.getLocation()
      )
    |
      token, " "
      order by
        l.getFile().getAbsolutePath(), l.getStartLine(), l.getStartColumn(), l.getEndLine(),
        l.getEndColumn(), token
    )
}
