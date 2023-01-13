/**
 * FunctionBodyFeatures.qll
 *
 * Contains logic relating to the `enclosingFunctionBody` and `enclosingFunctionName` features.
 */

import java
private import FeaturizationConfig
private import semmle.code.java.dataflow.DataFlow::DataFlow as DataFlow

/**
 * Gets a tokenized representation of the AST node for use in the `enclosingFunctionBody` feature.
 */
string getTokenizedAstNode(Top top) {
  result = top.(Variable).getName()
  or
  result = top.(Field).getName()
  or
  result = top.(Literal).getValue()
}

/** Gets an AST node within the function `f` that we should featurize. */
pragma[inline]
Element getAnAstNodeToFeaturize(Callable c) {
  result.(Stmt).getEnclosingCallable() = c or
  result.(Expr).getEnclosingCallable() = c
}

/** DEPRECATED: Alias for getAnAstNodeToFeaturize */
deprecated Top getAnASTNodeToFeaturize(Callable c) { result = getAnAstNodeToFeaturize(c) }

/**
 * Get the enclosing function for an endpoint.
 *
 * This is used to compute the `enclosingFunctionBody` and `enclosingFunctionName` features.
 */
Callable getRepresentativeFunctionForEndpoint(DataFlow::Node endpoint) {
  // Performance optimization: Restrict the set of endpoints to the endpoints to featurize.
  endpoint = any(FeaturizationConfig cfg).getAnEndpointToFeaturize() and
  result = endpoint.getEnclosingCallable()
}

/** Returns an AST node within the function `f` that an associated token feature. */
Element getAnAstNodeWithAFeature(Callable c) {
  // Performance optimization: Restrict the set of functions to those containing an endpoint to featurize.
  c = getRepresentativeFunctionForEndpoint(any(FeaturizationConfig cfg).getAnEndpointToFeaturize()) and
  result = getAnAstNodeToFeaturize(c)
}

/** DEPRECATED: Alias for getAnAstNodeWithAFeature */
deprecated Element getAnASTNodeWithAFeature(Callable c) { result = getAnAstNodeWithAFeature(c) }

/** Returns the number of source-code characters in a function. */
int getNumCharsInFunction(Callable c) {
  result =
    strictsum(Element element |
      element = getAnAstNodeWithAFeature(c)
    |
      getTokenizedAstNode(element).length()
    )
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
string getBodyTokensFeature(Callable c) {
  // Performance optimization: If a function has more than 256 body subtokens, then featurize it as
  // absent. This approximates the behavior of the classifier on non-generic body features where
  // large body features are replaced by the absent token.
  //
  // We count nodes instead of tokens because tokens are often not unique.
  strictcount(Element element |
    element = getAnAstNodeToFeaturize(c) and
    exists(getTokenizedAstNode(element))
  ) <= 256 and
  // Performance optimization: If a function has more than getMaxChars() characters in its body subtokens,
  // then featurize it as absent.
  getNumCharsInFunction(c) <= getMaxChars() and
  result =
    strictconcat(Location l, string token |
      // The use of a nested exists here allows us to avoid duplicates due to two AST nodes in the
      // same location featurizing to the same token. By using a nested exists, we take only unique
      // (location, token) pairs.
      exists(Element element |
        element = getAnAstNodeToFeaturize(c) and
        token = getTokenizedAstNode(element) and
        l = element.getLocation()
      )
    |
      token, " "
      order by
        l.getFile().getAbsolutePath(), l.getStartLine(), l.getStartColumn(), l.getEndLine(),
        l.getEndColumn(), token
    )
}
