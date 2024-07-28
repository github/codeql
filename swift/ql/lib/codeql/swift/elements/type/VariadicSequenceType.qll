private import codeql.swift.generated.type.VariadicSequenceType

/**
 * A variadic sequence type, that is, an array-like type that holds
 * variadic arguments. For example the type `Int...` of `args` in:
 * ```
 * func myVarargsFunction(args: Int...) {
 *   ...
 * }
 * ```
 */
class VariadicSequenceType extends Generated::VariadicSequenceType { }
