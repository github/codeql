/**
 * @name Static name resolution
 * @description Static name references that could be resolved to a target
 * @kind problem
 * @problem.severity recommendation
 * @id unified/diagnostic/static-name-resolution
 * @tags meta
 * @precision very-low
 */

import unified
import codeql.unified.internal.StaticNameBinding
import codeql.unified.internal.AnalysisQuality

from StaticNameResolutionStats::Candidate c, NameBindingNode target
where target = c.getTarget()
select c, "Resolved to $@", target, target.toString()
