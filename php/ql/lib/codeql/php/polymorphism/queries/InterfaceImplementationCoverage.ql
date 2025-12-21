/**
 * @name Interface Implementation Coverage
 * @description Analyzes which interfaces are properly implemented across the codebase
 * @kind table
 * @tags polymorphism
 *       interface
 *       analysis
 */

import php
import codeql.php.polymorphism.Polymorphism
import codeql.php.polymorphism.InterfaceDispatch

/**
 * Show interface implementation statistics
 */
from Interface iface, int implementationCount
where
  implementationCount = count(Class c | classImplementsInterface(c, iface))
select iface.getFullyQualifiedName() as interface_name,
  implementationCount as implementations,
  count(Method m | iface.hasMethod(m.getName())) as required_methods
order by implementationCount desc
