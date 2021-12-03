/**
 * @name Unnecessary import
 * @description A redundant 'import' statement introduces unnecessary and undesirable
 *              dependencies.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/unused-import
 * @tags maintainability
 *       external/cwe/cwe-561
 */

import java

string neededByJavadoc(JavadocElement c) {
  result = c.getText().regexpCapture(".*\\{@link(?:plain)?\\s+(\\w+)\\b.*\\}.*", 1) or
  result = c.(ThrowsTag).getExceptionName() or
  result = c.(SeeTag).getReference()
}

Annotation nestedAnnotation(Annotation a) { result.getAnnotatedElement().(Expr).getParent+() = a }

RefType neededByAnnotation(Annotation a) {
  exists(TypeAccess t | t.getParent+() = a | result = t.getType().(RefType).getSourceDeclaration())
  or
  exists(ArrayTypeAccess at | at.getParent+() = a |
    result = at.getType().(Array).getElementType().(RefType).getSourceDeclaration()
  )
  or
  exists(VarAccess va | va.getParent+() = a | result = va.getVariable().(Field).getDeclaringType())
  or
  result = a.getType()
  or
  result = a.getType().(NestedType).getEnclosingType+()
  or
  result = neededByAnnotation(nestedAnnotation(a))
}

RefType neededType(CompilationUnit cu) {
  // Annotations
  exists(Annotation a | a.getAnnotatedElement().getCompilationUnit() = cu |
    result = neededByAnnotation(a)
  )
  or
  // type accesses
  exists(TypeAccess t | t.getCompilationUnit() = cu |
    result = t.getType().(RefType).getSourceDeclaration()
  )
  or
  exists(ArrayTypeAccess at | at.getCompilationUnit() = cu |
    result = at.getType().(Array).getElementType().(RefType).getSourceDeclaration()
  )
  or
  // throws clauses
  exists(Callable c | c.getCompilationUnit() = cu | result = c.getAnException().getType())
  or
  // Javadoc
  exists(JavadocElement j | cu.getFile() = j.getFile() | result.getName() = neededByJavadoc(j))
}

RefType importedType(Import i) {
  result = i.(ImportOnDemandFromPackage).getAnImport() or
  result = i.(ImportOnDemandFromType).getAnImport() or
  result = i.(ImportType).getImportedType()
}

predicate neededImport(Import i) { importedType(i) = neededType(i.getCompilationUnit()) }

from Import i
where
  not neededImport(i) and
  not i instanceof ImportStaticOnDemand and
  not i instanceof ImportStaticTypeMember
select i, "The statement '" + i + "' is unnecessary."
