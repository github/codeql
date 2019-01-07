/**
 * @name Ineffective parameter type
 * @description Omitting the name of a parameter causes its type annotation to be parsed as the name.
 * @kind problem
 * @problem.severity warning
 * @id js/ineffective-parameter-type
 * @precision high
 * @tags correctness
 *       typescript
 */

import javascript

/**
 * Holds if there is a predefined type of the given name, and a parameter
 * of that name is likely intended to be typed.
 */
predicate isCommonPredefinedTypeName(string name) {
  name = "string" or
  name = "number" or
  name = "boolean"
}

/**
 * Any local type declaration, excluding imported names that are not explicitly used as types.
 */
class DefiniteTypeDecl extends TypeDecl {
  DefiniteTypeDecl() {
    this = any(ImportSpecifier im).getLocal() implies exists(getLocalTypeName().getAnAccess())
  }
}

from SimpleParameter parameter, Function function, Locatable link, string linkText
where
  function.getFile().getFileType().isTypeScript() and
  function.getAParameter() = parameter and
  not function.hasBody() and
  not exists(parameter.getTypeAnnotation()) and
  (
    isCommonPredefinedTypeName(parameter.getName()) and
    link = parameter and
    linkText = "predefined type '" + parameter.getName() + "'"
    or
    exists(DefiniteTypeDecl decl, LocalTypeName typename |
      decl = typename.getFirstDeclaration() and
      parameter.getVariable().getScope().getOuterScope*() = typename.getScope() and
      decl.getName() = parameter.getName() and
      link = decl and
      linkText = decl.describe()
    )
  )
select parameter,
  "The parameter '" + parameter.getName() + "' has type 'any', but its name coincides with the $@.",
  link, linkText
