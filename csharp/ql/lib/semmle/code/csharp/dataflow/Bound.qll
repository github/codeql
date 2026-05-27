/**
 * Provides classes for representing abstract bounds for use in, for example, range analysis.
 */
overlay[local?]
module;

private import csharp as CS
private import internal.rangeanalysis.BoundSpecific
private import internal.rangeanalysis.BoundSpecific as BoundSpecific
private import codeql.rangeanalysis.Bound as SharedBound

private module BoundImpl = SharedBound::Bound<CS::Location, BoundSpecific::BoundDefs>;

/**
 * A bound that may be inferred for an expression plus/minus an integer delta.
 */
class Bound = BoundImpl::Bound;

/**
 * The bound that corresponds to the integer 0. This is used to represent all
 * integer bounds as bounds are always accompanied by an added integer delta.
 */
class ZeroBound = BoundImpl::ZeroBound;

/**
 * A bound corresponding to the value of an SSA variable.
 */
class SsaBound = BoundImpl::SsaBound;

/**
 * A bound that corresponds to the value of a specific expression that might be
 * interesting, but isn't otherwise represented by the value of an SSA variable.
 */
class ExprBound = BoundImpl::ExprBound;