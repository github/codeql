import swift
private import codeql.swift.dataflow.DataFlow

/**
 * A `Content` that should be implicitly regarded as tainted whenever an object with such `Content`
 * is itself tainted.
 *
 * For example, if we had a type `class Container { var field: Contained }`, then by default a tainted
 * `Container` and a `Container` with a tainted `Contained` stored in its `field` are distinct.
 *
 * If `any(DataFlow::FieldContent fc | fc.getField().hasQualifiedName("Container", "field"))` was
 * included in this type however, then a tainted `Container` would imply that its `field` is also
 * tainted (but not vice versa).
 */
abstract class TaintInheritingContent extends DataFlow::Content { }
