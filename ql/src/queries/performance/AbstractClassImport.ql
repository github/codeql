/**
 * @name Bidirectional imports for abstract classes
 * @description An abstract class should import each of its subclasses, unless it is meant as an extension point, in which case it should import none of them.
 * @kind problem
 * @problem.severity error
 * @id ql/abstract-class-import
 * @tags correctness
 *       performance
 * @precision high
 */

import ql
import codeql_ql.ast.internal.Module

File imports(File file) {
  exists(Import imp |
    imp.getLocation().getFile() = file and
    result = imp.getResolvedModule().getFile()
  )
}

/** Gets a non-abstract subclass of `ab` that is defined in a different file */
Class concreteExternalSubclass(Class ab) {
  ab.isAbstract() and
  not result.isAbstract() and
  result.getType().getASuperType*() = ab.getType() and
  result.getLocation().getFile() != ab.getLocation().getFile()
}

/** Holds if there is a bidirectional import between the abstract class `ab` and its subclass `sub` */
predicate bidirectionalImport(Class ab, Class sub) {
  sub = concreteExternalSubclass(ab) and
  sub.getLocation().getFile() = imports*(ab.getLocation().getFile())
}

predicate stats(Class ab, int imports, int nonImports) {
  ab.isAbstract() and
  imports =
    strictcount(Class sub | sub = concreteExternalSubclass(ab) and bidirectionalImport(ab, sub)) and
  nonImports =
    strictcount(Class sub | sub = concreteExternalSubclass(ab) and not bidirectionalImport(ab, sub))
}

predicate alert(Class ab, string msg, Class sub, Class sub2) {
  sub = concreteExternalSubclass(ab) and
  sub2 = concreteExternalSubclass(ab) and
  exists(int imports, int nonImports | stats(ab, imports, nonImports) |
    (imports < 10 or nonImports < 10) and // if this is not the case, it's likely intended
    (
      // report whichever of imports or nonimports there are more of; both if equal
      imports >= nonImports and
      not bidirectionalImport(ab, sub) and
      sub2 =
        min(Class other |
          other = concreteExternalSubclass(ab) and
          bidirectionalImport(ab, other)
        |
          other order by other.getLocation().toString()
        ) and
      msg =
        "This abstract class doesn't import its subclass $@ but imports " + imports +
          " other subclasses, such as $@."
      or
      nonImports >= imports and
      bidirectionalImport(ab, sub) and
      sub2 =
        min(Class other |
          other = concreteExternalSubclass(ab) and
          not bidirectionalImport(ab, other)
        |
          other order by other.getLocation().toString()
        ) and
      msg =
        "This abstract class imports its subclass $@ but doesn't import " + nonImports +
          " other subclasses, such as $@."
    )
  )
}

from Class ab, string msg, Class sub, Class sub2
where alert(ab, msg, sub, sub2)
select ab, msg, sub, sub.getName(), sub2, sub2.getName()
