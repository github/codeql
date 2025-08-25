/**
 * Provides classes that define run-time callables. Run-time callables are
 * those callables that may actually be called at run-time (that is, neither
 * abstract callables nor callables defined in an interface).
 */

import csharp

/**
 * A run-time callable. That is, a callable that is neither abstract
 * nor defined in an interface.
 */
class RuntimeCallable extends Callable {
  RuntimeCallable() {
    not this.(Modifiable).isAbstract() and
    (
      not this.getDeclaringType() instanceof Interface or
      this.(Virtualizable).isVirtual()
    )
  }
}

/** A run-time method. */
class RuntimeMethod extends RuntimeCallable, Method { }

/** A run-time instance method. */
class RuntimeInstanceMethod extends RuntimeMethod {
  RuntimeInstanceMethod() { not this.isStatic() }
}

/** A run-time operator. */
class RuntimeOperator extends Operator, RuntimeCallable { }

/** A run-time accessor. */
class RuntimeAccessor extends Accessor, RuntimeCallable { }

/** A run-time instance accessor. */
class RuntimeInstanceAccessor extends RuntimeAccessor {
  RuntimeInstanceAccessor() { not this.isStatic() }
}
