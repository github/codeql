/**
 * @name Importing value of mutable attribute
 * @description Importing the value of a mutable attribute directly means that changes in global state will not be observed locally.
 * @kind problem
 * @tags reliability
 *       maintainability
 *       modularity
 * @problem.severity warning
 * @sub-severity high
 * @precision medium
 * @id py/import-of-mutable-attribute
 */

import python
import semmle.python.filters.Tests

from ImportMember im, ModuleValue m, AttrNode store_attr, string name
where
  m.importedAs(im.getModule().(ImportExpr).getImportedModuleName()) and
  im.getName() = name and
  /* Modification must be in a function, so it can occur during lifetime of the import value */
  store_attr.getScope() instanceof Function and
  /* variable resulting from import must have a long lifetime */
  not im.getScope() instanceof Function and
  store_attr.isStore() and
  store_attr.getObject(name).pointsTo(m) and
  /* Import not in same module as modification. */
  not im.getEnclosingModule() = store_attr.getScope().getEnclosingModule() and
  /* Modification is not in a test */
  not store_attr.getScope().getScope*() instanceof TestScope
select im,
  "Importing the value of '" + name +
    "' from $@ means that any change made to $@ will be not be observed locally.", m,
  "module " + m.getName(), store_attr, m.getName() + "." + store_attr.getName()
