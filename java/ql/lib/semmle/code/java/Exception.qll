/**
 * Provides classes and predicates for working with Java exceptions.
 */

import Element
import Type

/**
 * An Exception represents an element listed in the `throws` clause
 * of a method of constructor.
 *
 * For example, `E` is an exception thrown by method `m` in
 * `void m() throws E;`, whereas `T` is an exception _type_ in
 * `class T extends Exception { }`.
 */
class Exception extends Element, @exception {
  /** Gets the type of this exception. */
  RefType getType() { exceptions(this, result, _) }

  /** Gets the callable whose `throws` clause contains this exception. */
  Callable getCallable() { exceptions(this, _, result) }

  /** Gets the name of this exception, that is, the name of its type. */
  override string getName() { result = this.getType().getName() }

  /** Holds if this exception has the specified `name`. */
  override predicate hasName(string name) { this.getType().hasName(name) }

  override string toString() { result = this.getType().toString() }

  override string getAPrimaryQlClass() { result = "Exception" }
}
