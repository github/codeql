/**
 * DEPRECATED: Use `semmle.code.cpp.ir.dataflow.TaintTracking` as a replacement.
 *
 * An IR taint tracking library that uses an IR DataFlow configuration to track
 * taint from user inputs as defined by `semmle.code.cpp.security.Security`.
 */

import cpp
import semmle.code.cpp.security.Security
private import semmle.code.cpp.ir.dataflow.internal.DefaultTaintTrackingImpl as DefaultTaintTrackingImpl

deprecated predicate predictableOnlyFlow = DefaultTaintTrackingImpl::predictableOnlyFlow/1;

deprecated predicate tainted = DefaultTaintTrackingImpl::tainted/2;

deprecated predicate taintedIncludingGlobalVars =
  DefaultTaintTrackingImpl::taintedIncludingGlobalVars/3;

deprecated predicate globalVarFromId = DefaultTaintTrackingImpl::globalVarFromId/1;

deprecated module TaintedWithPath = DefaultTaintTrackingImpl::TaintedWithPath;
