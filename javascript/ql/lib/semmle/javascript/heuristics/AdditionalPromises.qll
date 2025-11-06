/**
 * Provides classes that heuristically increase the extent of `StandardLibrary::PromiseDefinition`.
 *
 * Note: This module should not be a permanent part of the standard library imports.
 */
overlay[local?]
module;

import javascript

private class PromotedPromiseCandidate extends PromiseDefinition, PromiseCandidate {
  override DataFlow::FunctionNode getExecutor() { result = this.getCallback(0) }
}
