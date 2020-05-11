/**
 * @name Module-level cyclic import
 * @description Module uses member of cyclically imported module, which can lead to failure at import time.
 * @kind problem
 * @tags reliability
 *       correctness
 *       types
 * @problem.severity error
 * @sub-severity low
 * @precision high
 * @comprehension 0.5
 * @id py/unsafe-cyclic-import
 */

import python
import Cyclic

// This is a potentially crashing bug if
// 1. the imports in the whole cycle are lexically outside a def (and so executed at import time)
// 2. there is a use ('M.foo' or 'from M import foo') of the imported module that is lexically outside a def
// 3. 'foo' is defined in M after the import in M which completes the cycle.
// then if we import the 'used' module, we will reach the cyclic import, start importing the 'using'
// module, hit the 'use', and then crash due to the imported symbol not having been defined yet
from ModuleValue m1, Stmt imp, ModuleValue m2, string attr, Expr use, ControlFlowNode defn
where failing_import_due_to_cycle(m1, m2, imp, defn, use, attr)
select use,
  "'" + attr + "' may not be defined if module $@ is imported before module $@, as the $@ of " +
    attr + " occurs after the cyclic $@ of " + m2.getName() + ".",
  // Arguments for the placeholders in the above message:
  m1, m1.getName(), m2, m2.getName(), defn, "definition", imp, "import"
