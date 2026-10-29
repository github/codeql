/**
 * @name Call graph
 * @description An edge in the call graph.
 * @kind problem
 * @problem.severity recommendation
 * @id rb/meta/call-graph
 * @tags meta
 * @precision very-low
 */

import codeql.ruby.AST

from Call invoke, Callable f
where invoke.getATarget() = f
select invoke, "Call to $@", f, f.toString()
