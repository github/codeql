/**
 * @name Inconsistent SAL annotation
 * @description Annotations are different between declaration and definition.
 * @kind problem
 * @id cpp/inconsistent-sal
 * @problem.severity warning
 * @tags reliability
 */

import SAL

/** Holds if `e` has SAL annotation `name`. */
predicate hasAnnotation(DeclarationEntry e, string name) {
  exists(SALAnnotation a |
    a.getMacro().getName() = name and
    a.getDeclarationEntry() = e
  )
}

/** Holds if `e` is annotated to take its annotation from its declaration. */
predicate inheritsDeclAnnotations(DeclarationEntry e) {
  // Is directly annotated
  e.isDefinition() and
  exists(SALAnnotation a | a.getMacro().getName() = "_Use_decl_annotations_" |
    a.getDeclarationEntry() = e
  )
  or
  // or is a parameter of a function with such an annotation
  inheritsDeclAnnotations(e.(ParameterDeclarationEntry).getFunctionDeclarationEntry())
}

from DeclarationEntry e1, DeclarationEntry e2, string name
where
  e1.getDeclaration() = e2.getDeclaration() and
  hasAnnotation(e1, name) and
  not hasAnnotation(e2, name) and
  not name = "_Use_decl_annotations_" and
  not inheritsDeclAnnotations(e2)
select e2,
  "Missing SAL annotation " + name + " in " + e2.toString() + " although it is present on $@.", e1,
  e1.toString()
