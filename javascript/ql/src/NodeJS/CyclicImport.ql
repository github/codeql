/**
 * @name Cyclic module import
 * @description If a module indirectly imports itself, some modules involved in the import cycle may end up
 *              with partially loaded dependencies. This is error-prone and should be avoided.
 * @kind problem
 * @problem.severity warning
 * @id js/node/cyclic-import
 * @tags reliability
 *       maintainability
 *       frameworks/node.js
 * @precision low
 */

import javascript

/**
 * Gets the shortest suffix of the path of `c1` that differs from the
 * corresponding suffix of `c2`; if that suffix is a proper suffix, it is
 * additionally prefixed with `.../`.
 */
string ppDiff(Container c1, Container c2) {
  relatedAncestors(c1, c2) and
  if c1.getBaseName() = c2.getBaseName()
  then result = ppDiff(c1.getParentContainer(), c2.getParentContainer()) + "/" + c1.getBaseName()
  else
    if
      not exists(c1.getParentContainer()) or
      sourceLocationPrefix(c1.getParentContainer().getAbsolutePath())
    then result = "/" + c1.getBaseName()
    else result = ".../" + c1.getBaseName()
}

/**
 * Holds if `c1` and `c2` are related modules (as determined by predicate
 * `relatedModules`), or (transitive) parent folders of such modules.
 *
 * This predicate is used to restrict the domain of `ppDiff`.
 */
predicate relatedAncestors(Container c1, Container c2) {
  exists(NodeModule m, NodeModule n | relatedModules(m, n) | c1 = m.getFile() and c2 = n.getFile())
  or
  relatedAncestors(c1.(Folder).getAChildContainer(), c2.(Folder).getAChildContainer())
}

/**
 * Gets a pretty-printed name for `m` that distinguishes it from `other`:
 * this is simply the name of `m` it is different from the name of `other`,
 * or else a suffix of the path of `m` that is different from `other` as
 * computed by `ppDiff`.
 */
string pp(NodeModule m, NodeModule other) {
  relatedModules(m, other) and
  if m.getName() = other.getName() and m != other
  then result = ppDiff(m.getFile(), other.getFile())
  else result = m.getName()
}

/**
 * Holds if `m` imports `n` or vice versa.
 *
 * This predicate is used to restrict the domain of `pp`.
 */
predicate relatedModules(NodeModule m, NodeModule n) {
  n = m.getAnImportedModule() or m = n.getAnImportedModule()
}

from NodeModule m, Require r, NodeModule imported, string msg, AstNode linktarget, string linktext
where
  r = m.getAnImport() and
  imported = r.getImportedModule() and
  if imported = m
  then
    // set linktarget and linktext to dummy values in this case
    msg = "directly imports itself" and linktarget = m and linktext = ""
  else
    // find an import in `imported` that (directly or indirectly) imports `m`
    exists(Require r2, Module imported2 |
      r2 = imported.getAnImport() and imported2 = r2.getImportedModule()
    |
      imported2.getAnImportedModule*() = m and
      msg = "imports module " + pp(imported, m) + ", which in turn $@ it" and
      linktarget = r2 and
      // check whether it is a direct or indirect import
      (
        if imported2 = m
        then linktext = "imports"
        else (
          // only report indirect imports if there is no direct import
          linktext = "indirectly imports" and not imported.getAnImportedModule() = m
        )
      )
    )
select r, "Module " + pp(m, imported) + " " + msg + ".", linktarget, linktext
