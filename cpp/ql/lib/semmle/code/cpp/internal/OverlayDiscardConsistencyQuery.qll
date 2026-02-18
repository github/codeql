/**
 * Provides consistency queries for checking that every database entity
 * that can be discarded (i.e. everything but `@compilation` and some external
 * entities) in an overlay database is indeed discarded.
 *
 * This validates that Overlay.qll's `getSingleLocationFilePath` and
 * `getMultiLocationFilePath` predicates cover all entity types.
 */

import cpp
private import Overlay

/**
 * Holds if `element` is not covered by the discard predicates in Overlay.qll.
 *
 * This query is intended to flag cases where new entity types are added
 * to the dbscheme but the corresponding discard predicate is not updated.
 *
 * An element is considered covered if it has a path via either
 * `getSingleLocationFilePath` or `getMultiLocationFilePath`.
 */
query predicate consistencyTest(Element element, string message) {
  (
    // Check that every @element has a path via the discard predicates
    not exists(getSingleLocationFilePath(element)) and
    not exists(getMultiLocationFilePath(element)) and
    // Exclude global/synthetic entities that don't need to be discarded
    not element instanceof @specifier and
    not element instanceof @builtintype and
    not element instanceof @derivedtype and
    not element instanceof @routinetype and
    not element instanceof @ptrtomember and
    not element instanceof @decltype and
    not element instanceof @type_operator and
    not element instanceof @specialnamequalifyingelement and
    // Exclude files/folders (handled separately by overlay infrastructure)
    not element instanceof @file and
    not element instanceof @folder and
    // Exclude XML entities (not C++ code)
    not element instanceof @xmllocatable and
    // Exclude compiler diagnostics (metadata, not source entities)
    not element instanceof @diagnostic and
    // Exclude usertypes without declarations (compiler built-ins like 'auto', '__va_list')
    not (element instanceof @usertype and not exists(@type_decl td | type_decls(td, element, _))) and
    // Exclude namespaces without declarations (global namespace)
    not (
      element instanceof @namespace and
      not exists(@namespace_decl nd | namespace_decls(nd, element, _, _))
    ) and
    // Exclude functions without declarations (compiler-generated like implicit operator=)
    not (
      element instanceof @function and not exists(@fun_decl fd | fun_decls(fd, element, _, _, _))
    ) and
    // Exclude variables without declarations (parameters of compiler-generated functions)
    not (
      element instanceof @variable and not exists(@var_decl vd | var_decls(vd, element, _, _, _))
    ) and
    exists(Location loc | loc = element.getLocation() |
      message =
        element.getPrimaryQlClasses() + " at " + loc.getFile().getRelativePath() + ":" +
          loc.getStartLine().toString() + " not covered by discard predicates"
    )
  )
}
