/**
 * Provides an abstract class for accurate modeling of flow through output
 * iterators.  To use this QL library, create a QL class extending
 * `IteratorReferenceFunction` with a characteristic predicate that selects the
 * function or set of functions you are modeling. Within that class, override
 * the predicates provided by `AliasFunction` to match the flow within that
 * function.
 */

import cpp
import semmle.code.cpp.models.Models

/**
 * A function which takes an iterator argument and returns a reference that
 * can be used to write to the iterator's underlying collection.
 */
abstract class IteratorReferenceFunction extends Function { }

/**
 * A function which takes a container and returns an iterator over that container.
 */
abstract class GetIteratorFunction extends Function {
  /**
   * Holds if the return value or buffer represented by `output` is an iterator over the container
   * passed in the argument, qualifier, or buffer represented by `input`.
   */
  abstract predicate getsIterator(FunctionInput input, FunctionOutput output);
}
