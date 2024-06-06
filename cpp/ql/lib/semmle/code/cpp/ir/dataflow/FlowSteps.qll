/**
 * This file provides an abstract class that can be used to model additional
 * object-to-field taint-flow.
 */

private import codeql.util.Unit
private import semmle.code.cpp.dataflow.new.DataFlow

/**
 * A `Content` that should be implicitly regarded as tainted whenever an object with such `Content`
 * is itself tainted.
 *
 * For example, if we had a type `struct Container { int field; }`, then by default a tainted
 * `Container` and a `Container` with a tainted `int` stored in its `field` are distinct.
 *
 * If `any(DataFlow::FieldContent fc | fc.getField().hasQualifiedName("Container", "field"))` was
 * included in this type however, then a tainted `Container` would imply that its `field` is also
 * tainted (but not vice versa).
 */
abstract class TaintInheritingContent extends DataFlow::Content { }
