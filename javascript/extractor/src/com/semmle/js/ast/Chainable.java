package com.semmle.js.ast;

/** A chainable expression, such as a member access or function call. */
public interface Chainable {
  /** Is this step of the chain optional? */
  abstract boolean isOptional();

  /** Is this on an optional chain? */
  abstract boolean isOnOptionalChain();
}
