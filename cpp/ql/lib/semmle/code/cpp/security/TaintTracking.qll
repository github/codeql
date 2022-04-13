/*
 * Support for tracking tainted data through the program. This is an alias for
 * `semmle.code.cpp.ir.dataflow.DefaultTaintTracking` provided for backwards
 * compatibility.
 *
 * Prefer to use `semmle.code.cpp.dataflow.TaintTracking` or
 * `semmle.code.cpp.ir.dataflow.TaintTracking` when designing new queries.
 */

import semmle.code.cpp.ir.dataflow.DefaultTaintTracking
