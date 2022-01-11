/*
 * FunctionBodyFeatures.qll
 *
 * Contains logic relating to the `enclosingFunctionBody` and `enclosingFunctionName` features.
 */

import javascript
private import CodeToFeatures
private import FeaturizationConfig

string getTokenizedAstNode(ASTNode node) {
  // NB: Unary and binary operator expressions e.g. -a, a + b and compound
  // assignments e.g. a += b can be identified by the expression type.
  result = node.(Identifier).getName()
  or
  // Computed property accesses for which we can predetermine the property being accessed.
  // NB: May alias with operators e.g. could have '+' as a property name.
  result = node.(IndexExpr).getPropertyName()
  or
  // We use `getRawValue` to give us distinct representations for `0xa`, `0xA`, and `10`.
  result = node.(NumberLiteral).getRawValue()
  or
  // We use `getValue` rather than `getRawValue` so we assign `"a"` and `'a'` the same representation.
  not node instanceof NumberLiteral and
  result = node.(Literal).getValue()
  or
  result = node.(TemplateElement).getRawValue()
}

/** Returns an AST node within the function `f` that we should featurize. */
pragma[inline]
ASTNode getAnASTNodeToFeaturize(Function f) {
  result.getParent*() = f and
  not result = f.getIdentifier() and
  exists(getTokenizedAstNode(result))
}

/**
 * Get a function containing the endpoint that is suitable for featurization. In general,
 * this associates an endpoint to multiple functions, since there may be more than one multiple entities to a single endpoint.
 */
Function getAFunctionForEndpoint(DataFlow::Node endpoint) {
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
  result = count(getAnASTNodeToFeaturize(function))
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

/** Holds if `location` is the location of an AST node within the entity `entity` and `token` is a node attribute associated with that AST node. */
predicate bodyTokens(DatabaseFeatures::Entity entity, Location location, string token) {
  // Performance optimization: Restrict the set of entities to those containing an endpoint to featurize.
  entity.getDefinedFunction() =
    getRepresentativeFunctionForEndpoint(any(FeaturizationConfig cfg).getAnEndpointToFeaturize()) and
  // Performance optimization: If a function has more than 256 body subtokens, then featurize it as absent. This
  // approximates the behavior of the classifer on non-generic body features where large body
  // features are replaced by the absent token.
  //
  // We count nodes instead of tokens because tokens are often not unique.
  strictcount(getAnASTNodeToFeaturize(entity.getDefinedFunction())) <= 256 and
  exists(ASTNode node |
    node = getAnASTNodeToFeaturize(entity.getDefinedFunction()) and
    token = getTokenizedAstNode(node) and
    location = node.getLocation()
  )
}
