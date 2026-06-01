/**
 * Provides classes for representing abstract bounds for use in, for example, range analysis.
 */
overlay[local?]
module;

private import java as J
private import internal.rangeanalysis.BoundSpecific as BoundSpecific
private import codeql.rangeanalysis.Bound as SharedBound

private module BoundImpl = SharedBound::Bound<J::Location, BoundSpecific::BoundDefs>;

import BoundImpl
