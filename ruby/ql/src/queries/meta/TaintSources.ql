/**
 * @name Taint sources
 * @description Sources of untrusted input.
 * @kind problem
 * @problem.severity recommendation
 * @id rb/meta/taint-sources
 * @tags meta
 * @precision very-low
 */

import internal.TaintMetrics

from string kind
select relevantTaintSource(kind), kind
