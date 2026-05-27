/**
 * Provides classes for representing abstract bounds for use in, for example, range analysis.
 */
overlay[local?]
module;

private import java as J
private import internal.rangeanalysis.BoundSpecific as BoundSpecific
private import codeql.rangeanalysis.Bound as SharedBound

module BoundInstantiation = SharedBound::Bound<J::Location, BoundSpecific::BoundDefs>;

class Bound = BoundInstantiation::Bound;

class ZeroBound = BoundInstantiation::ZeroBound;

class SsaBound = BoundInstantiation::SsaBound;

class ExprBound = BoundInstantiation::ExprBound;