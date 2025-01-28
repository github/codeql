/**
 * Provides classes and predicates for simple data-flow reachability suitable
 * for tracking types.
 */

private import powershell
private import semmle.code.powershell.typetracking.internal.TypeTrackingImpl as Impl
import Impl::Shared::TypeTracking<Location, Impl::TypeTrackingInput>
