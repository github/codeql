/**
 * @name Unused variable, import, function or class
 * @description Unused variables, imports, functions or classes may be a symptom of a bug
 *              and should be examined carefully.
 * @kind problem
 * @problem.severity recommendation
 * @id js/unused-local-variable
 * @tags maintainability
 * @precision very-high
 */

import javascript

/**
 * A local variable that is neither used nor exported, and is not a parameter
 * or a function name.
 */
class UnusedLocal extends LocalVariable {
  UnusedLocal() {
    not exists(getAnAccess()) and
    not exists(Parameter p | this = p.getAVariable()) and
    not exists(FunctionExpr fe | this = fe.getVariable()) and
    not exists(ClassExpr ce | this = ce.getVariable()) and
    not exists(ExportDeclaration ed | ed.exportsAs(this, _)) and
    not exists(LocalVarTypeAccess type | type.getVariable() = this)
  }
}

/**
 * Holds if `v` is mentioned in a JSDoc comment in the same file, and that file
 * contains externs declarations.
 */
predicate mentionedInJSDocComment(UnusedLocal v) {
  exists (Externs ext, JSDoc jsdoc |
    ext = v.getADeclaration().getTopLevel() and jsdoc.getComment().getTopLevel() = ext |
    jsdoc.getComment().getText().regexpMatch("(?s).*\\b" + v.getName() + "\\b.*")
  )
}

/**
 * Holds if `v` is declared in an object pattern that also contains a rest pattern.
 *
 * This is often used to filter out properties; for example, `var { x: v, ...props } = o`
 * copies all properties of `o` into `props`, except for `x` which is copied into `v`.
 */
predicate isPropertyFilter(UnusedLocal v) {
  exists (ObjectPattern op | exists(op.getRest()) |
    op.getAPropertyPattern().getValuePattern() = v.getADeclaration()
  )
}

/**
 * Holds if `v` is an import of React, and there is a JSX element that implicitly
 * references it.
 */
predicate isReactImportForJSX(UnusedLocal v) {
  exists (ImportSpecifier is |
    is.getLocal() = v.getADeclaration() and
    exists (JSXNode jsx | jsx.getTopLevel() = is.getTopLevel()) |
    v.getName() = "React" or
    // also accept legacy `@jsx` pragmas
    exists (JSXPragma p | p.getTopLevel() = is.getTopLevel() | p.getDOMName() = v.getName())
  )
}

/**
 * Holds if `decl` is both a variable declaration and a type declaration,
 * and the declared type has a use.
 */
predicate isUsedAsType(VarDecl decl) {
  exists (decl.(TypeDecl).getLocalTypeName().getAnAccess())
}

/**
 * Holds if `decl` declares a local alias for a namespace that is used from inside a type.
 */
predicate isUsedAsNamespace(VarDecl decl) {
  exists (decl.(LocalNamespaceDecl).getLocalNamespaceName().getAnAccess())
}

/**
 * Holds if the given identifier belongs to a decorated class or enum.
 */
predicate isDecorated(VarDecl decl) {
  exists (ClassDefinition cd | cd.getIdentifier() = decl | exists(cd.getDecorator(_))) or
  exists (EnumDeclaration cd | cd.getIdentifier() = decl | exists(cd.getDecorator(_)))
}

/**
 * Holds if this is the name of an enum member.
 */
predicate isEnumMember(VarDecl decl) {
  decl = any(EnumMember member).getIdentifier()
}

/**
 * Gets a description of the declaration `vd`, which is either of the form "function f" if
 * it is a function name, or "variable v" if it is not.
 */
string describe(VarDecl vd) {
  if vd = any(Function f).getId() then
    result = "function " + vd.getName()
  else if vd = any(ClassDefinition c).getIdentifier() then
    result = "class " + vd.getName()
  else if (vd = any(ImportSpecifier im).getLocal() or vd = any(ImportEqualsDeclaration im).getId()) then
    result = "import " + vd.getName()
  else
    result = "variable " + vd.getName()
}

from VarDecl vd, UnusedLocal v
where v = vd.getVariable() and
      // exclude variables mentioned in JSDoc comments in externs
      not mentionedInJSDocComment(v) and
      // exclude variables used to filter out unwanted properties
      not isPropertyFilter(v) and
      // exclude imports of React that are implicitly referenced by JSX
      not isReactImportForJSX(v) and
      // exclude names that are used as types
      not isUsedAsType(vd) and
      // exclude names that are used as namespaces from inside a type
      not isUsedAsNamespace(vd) and
      // exclude decorated functions and classes
      not isDecorated(vd) and
      // exclude names of enum members; they also define property names
      not isEnumMember(vd) and
      // ignore ambient declarations - too noisy
      not vd.isAmbient()
select vd, "Unused " + describe(vd) + "."
