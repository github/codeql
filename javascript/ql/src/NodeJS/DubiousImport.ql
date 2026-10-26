/**
 * @name Dubious import
 * @description Importing a symbol from a module that does not export it most likely indicates a bug.
 * @kind problem
 * @problem.severity warning
 * @id js/node/import-without-export
 * @tags reliability
 *       maintainability
 *       frameworks/node.js
 * @precision low
 */

import javascript

/** Holds if `m` is likely to have exports that are not picked up by the analysis. */
predicate hasUntrackedExports(NodeModule m) {
  // look for assignments of the form `module.exports[p] = ...`, where we cannot
  // determine the name of the exported property being assigned
  exists(DataFlow::PropWrite pwn |
    pwn.getBase().analyze().getAValue() = m.getAModuleExportsValue() and
    not exists(pwn.getPropertyName())
  )
  or
  // look for assignments of the form `module.exports = exp` where `exp` is indefinite
  exists(AbstractModuleObject am, AnalyzedPropertyWrite apw, DataFlow::AnalyzedNode exp |
    am.getModule() = m and
    apw.writes(am, "exports", exp) and
    exp.getAValue().isIndefinite(_)
  )
  or
  // look for function calls of the form `f(module.exports)`
  exists(InvokeExpr invk | invk.getAnArgument().analyze().getAValue() = m.getAModuleExportsValue())
}

/**
 * Holds if there is an assignment anywhere defining `prop` on the result of
 * a `require` import of module `m`.
 */
predicate propDefinedOnRequire(NodeModule m, string prop) {
  exists(DataFlow::ModuleImportNode imp |
    imp.asExpr().(Require).getImportedModule() = m and
    exists(imp.getAPropertyWrite(prop))
  )
}

/**
 * Holds if the base expression of `pacc` could refer to the result of
 * a `require` import of module `m`.
 */
predicate propAccessOn(PropAccess pacc, NodeModule m) {
  exists(DataFlow::ModuleImportNode imp |
    imp.asExpr().(Require).getImportedModule() = m and
    imp.flowsToExpr(pacc.getBase())
  )
}

from NodeModule m, PropAccess pacc, string prop
where
  propAccessOn(pacc, m) and
  count(NodeModule mm | propAccessOn(pacc, mm)) = 1 and
  prop = pacc.getPropertyName() and
  // m doesn't export 'prop'
  not prop = m.getAnExportedSymbol() and
  // 'prop' isn't otherwise defined on m
  not propDefinedOnRequire(m, prop) and
  // m doesn't use complicated exports
  not hasUntrackedExports(m)
select pacc, "Module $@ does not export symbol " + prop + ".", m, m.getName()
