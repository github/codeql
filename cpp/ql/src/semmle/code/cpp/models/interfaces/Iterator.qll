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
