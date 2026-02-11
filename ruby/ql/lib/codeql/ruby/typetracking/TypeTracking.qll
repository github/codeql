/**
 * Provides classes and predicates for simple data-flow reachability suitable
 * for tracking types.
 */

private import codeql.ruby.AST
private import codeql.ruby.typetracking.internal.TypeTrackingImpl as Impl
import Impl::Shared::TypeTracking<Location, Impl::TypeTrackingInput>
