/**
 * This module should provide a class hierarchy corresponding to a parse tree of regular expressions.
 *
 * Since the javascript extractor already provides such a hierarchy, we simply import that.
 */

import javascript

/**
 * Holds if the regular expression should not be considered.
 *
 * For javascript we make the pragmatic performance optimization to ignore minified files.
 */
predicate isExcluded(RegExpParent parent) { parent.(Expr).getTopLevel().isMinified() }
