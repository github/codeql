/**
 * Provides abstract classes for representing callable entities and call sites
 * across different binary formats (CIL, x86, etc.).
 *
 * This module defines a common interface that allows queries to work uniformly
 * across binary types while allowing format-specific implementations.
 */

/**
 * An abstract callable entity (method, function, etc.) in a binary.
 * Subclasses provide format-specific implementations.
 */
abstract class Callable extends string {
  Callable() { this = this.getIdentifier() }

  /**
   * Gets a unique identifier for this callable.
   * For CIL, this is the fully qualified method name.
   * For x86, this might be a symbol name or address.
   */
  abstract string getIdentifier();

  /**
   * Gets a human-readable name for this callable.
   */
  abstract string getName();

  /**
   * Gets the location of this callable in the source/binary.
   */
  abstract Location getLocation();

  /**
   * Gets a call site within this callable that calls another callable.
   */
  abstract CallSite getACallSite();

  /**
   * Holds if this callable is publicly accessible (exported, public, etc.).
   */
  abstract predicate isPublic();
}

/**
 * An abstract call site - a location where one callable invokes another.
 */
abstract class CallSite extends string {
  CallSite() { this = this.getIdentifier() }

  /**
   * Gets a unique identifier for this call site.
   */
  abstract string getIdentifier();

  /**
   * Gets the callable containing this call site.
   */
  abstract Callable getEnclosingCallable();

  /**
   * Gets the target of this call, if it can be resolved.
   * Returns the identifier that can be matched against models.
   */
  abstract string getCallTargetIdentifier();

  /**
   * Gets the location of this call site.
   */
  abstract Location getLocation();
}

/**
 * Holds if `caller` directly calls `callee` (by identifier).
 */
predicate directlyCallsIdentifier(Callable caller, string calleeIdentifier) {
  exists(CallSite cs |
    cs.getEnclosingCallable() = caller and
    cs.getCallTargetIdentifier() = calleeIdentifier
  )
}
