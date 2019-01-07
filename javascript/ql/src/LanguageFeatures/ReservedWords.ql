/**
 * @name Reserved word used as variable name
 * @description Future reserved words should not be used as variable names.
 * @kind problem
 * @problem.severity recommendation
 * @id js/use-of-reserved-word
 * @tags maintainability
 *       language-features
 * @precision very-high
 * @deprecated This is no longer a problem with modern browsers. Deprecated since 1.17.
 */

import javascript

from Identifier id
where
  id
      .getName()
      .regexpMatch("class|const|enum|export|extends|import|super|implements|interface|let|package|private|protected|public|static|yield") and
  not exists(DotExpr de | id = de.getProperty()) and
  not exists(Property prop | id = prop.getNameExpr()) and
  // exclude JSX attribute names
  not exists(JSXElement e | id = e.getAnAttribute().getNameExpr())
select id, "Identifier name is a reserved word."
