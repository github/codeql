/**
 * @name Importing value of mutable attribute
 * @description Importing the value of a mutable attribute directly means that changes in global state will not be observed locally.
 * @kind problem
 * @tags quality
 *       reliability
 *       correctness
 * @problem.severity warning
 * @sub-severity high
 * @precision medium
 * @id py/import-of-mutable-attribute
 */

import python
import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.internal.ImportResolution
import semmle.python.filters.Tests

from ImportMember im, Module m, DataFlow::AttrWrite store_attr, string name
where
  ImportResolution::getImmediateModuleReference(m).asExpr() = im.getModule() and
  im.getName() = name and
  /* Modification must be in a function, so it can occur during lifetime of the import value */
  store_attr.getObject().getScope() instanceof Function and
  /* variable resulting from import must have a long lifetime */
  not im.getScope() instanceof Function and
  store_attr.getAttributeName() = name and
  ImportResolution::getModuleReference(m) = store_attr.getObject() and
  /* Import not in same module as modification. */
  not im.getEnclosingModule() = store_attr.getObject().getScope().getEnclosingModule() and
  /* Modification is not in a test */
  not store_attr.getObject().getScope().getScope*() instanceof TestScope
select im,
  "Importing the value of '" + name +
    "' from $@ means that any change made to $@ will be not be observed locally.", m,
  "module " + ImportResolution::moduleName(m), store_attr,
  ImportResolution::moduleName(m) + "." + store_attr.getAttributeName()
