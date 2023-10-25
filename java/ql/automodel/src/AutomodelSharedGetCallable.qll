/**
 * An automodel extraction mode instantiates this interface to define how to access
 * the callable that's associated with an endpoint.
 */
signature module GetCallableSig {
  /**
   * A callable is the definition of a method, function, etc. - something that can be called.
   */
  class Callable;

  /**
   * An endpoint is a potential candidate for modeling. This will typically be bound to the language's
   * DataFlow node class, or a subtype thereof.
   */
  class Endpoint;

  /**
   * Gets the callable that's associated with the given endpoint.
   */
  Callable getCallable(Endpoint endpoint);
}
