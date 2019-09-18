/**
 * @name Unknown directive
 * @description An unknown directive has no effect and may indicate a misspelling.
 * @kind problem
 * @problem.severity warning
 * @id js/unknown-directive
 * @tags correctness
 * @precision high
 */

import javascript

from Directive d
where
  not d instanceof KnownDirective and
  // but exclude attribute top-levels: `<a href="javascript:'some-attribute-string'">`
  not d.getParent() instanceof CodeInAttribute
select d, "Unknown directive: '" + truncate(d.getDirectiveText(), 20, " ... (truncated)") + "'."
