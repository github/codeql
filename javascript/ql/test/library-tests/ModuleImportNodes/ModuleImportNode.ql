import javascript

from DataFlow::ModuleImportNode m, Identifier use
where m.flowsToExpr(use)
select m, m.getPath(), use, use.getName()
