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
  not d instanceof Directive::KnownDirective and
  // ignore ":" pseudo-directive sometimes seen in dual-use shell/node.js scripts
  not d.getExpr().getStringValue() = ":" and
  // but exclude attribute top-levels: `<a href="javascript:'some-attribute-string'">`
  not d.getParent() instanceof CodeInAttribute and
  // exclude babel generated directives like "@babel/helpers - typeof".
  not d.getDirectiveText().matches("@babel/helpers%")
select d, "Unknown directive: '" + truncate(d.getDirectiveText(), 20, " ... (truncated)") + "'."
