/**
 * @name Import graph
 * @description An edge in the import graph.
 * @kind problem
 * @problem.severity recommendation
 * @id js/meta/alerts/import-graph
 * @tags meta
 * @precision very-low
 */

import javascript

from Import imprt, Module target
where target = imprt.getImportedModule()
select imprt, "Import targeting $@", target, target.getFile().getRelativePath()
