package com.semmle.js.ast;

/** A chainable expression, such as a member access or function call. */
public interface Chainable {
  /** Is this step of the chain optional? */
  abstract boolean isOptional();

  /** Is this on an optional chain? */
  abstract boolean isOnOptionalChain();

  /**
   * Returns true if a chainable node is on an optional chain.
   *
   * @param optional true if the node in question is itself optional (has the ?. token)
   * @param base the calle or base of the optional access
   */
  public static boolean isOnOptionalChain(boolean optional, Expression base) {
    return optional || base instanceof Chainable && ((Chainable) base).isOnOptionalChain();
  }
}
