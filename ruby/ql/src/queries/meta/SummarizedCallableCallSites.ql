/**
 * @name Summarized callable call sites
 * @description A call site for which we have a summarized callable
 * @kind problem
 * @problem.severity recommendation
 * @id rb/meta/summarized-callable-call-sites
 * @tags meta
 * @precision very-low
 */

import codeql.ruby.AST
import codeql.ruby.dataflow.FlowSummary

from Call invoke, SummarizedCallable f
where f.getACall() = invoke or f.getACallSimple() = invoke
select invoke, "Call to " + f
