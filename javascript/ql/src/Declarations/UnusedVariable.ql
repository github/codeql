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
import Declarations.UnusedVariable

/**
 * Holds if `v` is mentioned in a JSDoc comment in the same file, and that file
 * contains externs declarations.
 */
predicate mentionedInJSDocComment(UnusedLocal v) {
  exists(Externs ext, JSDoc jsdoc |
    ext = v.getADeclaration().getTopLevel() and jsdoc.getComment().getTopLevel() = ext
  |
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
  exists(ObjectPattern op | exists(op.getRest()) |
    op.getAPropertyPattern().getValuePattern() = v.getADeclaration()
  )
}

predicate hasJsxInScope(UnusedLocal v) {
  any(JsxNode n).getParent+() = v.getScope().getScopeElement()
}

/**
 * Holds if `v` is a "React" variable that is implicitly used by a JSX element.
 */
predicate isReactForJsx(UnusedLocal v) {
  hasJsxInScope(v) and
  (
    v.getName() = "React"
    or
    exists(TopLevel tl | tl = v.getADeclaration().getTopLevel() |
      // legacy `@jsx` pragmas
      exists(JsxPragma p | p.getTopLevel() = tl | p.getDomName() = v.getName())
      or
      // JSX pragma from a .babelrc file
      exists(Babel::TransformReactJsxConfig plugin |
        plugin.appliesTo(tl) and
        plugin.getJsxFactoryVariableName() = v.getName()
      )
    )
    or
    exists(JsonObject tsconfig |
      tsconfig.isTopLevel() and tsconfig.getFile().getBaseName() = "tsconfig.json"
    |
      v.getName() =
        tsconfig
            .getPropValue("compilerOptions")
            .getPropValue(["jsxFactory", "jsxFragmentFactory"])
            .getStringValue()
    )
  )
}

/**
 * Holds if `decl` is both a variable declaration and a type declaration,
 * and the declared type has a use.
 */
predicate isUsedAsType(VarDecl decl) { exists(decl.(TypeDecl).getLocalTypeName().getAnAccess()) }

/**
 * Holds if `decl` declares a local alias for a namespace that is used from inside a type.
 */
predicate isUsedAsNamespace(VarDecl decl) {
  exists(decl.(LocalNamespaceDecl).getLocalNamespaceName().getAnAccess())
}

/**
 * Holds if the given identifier belongs to a decorated class or enum.
 */
predicate isDecorated(VarDecl decl) {
  exists(ClassDefinition cd | cd.getIdentifier() = decl | exists(cd.getDecorator(_)))
  or
  exists(EnumDeclaration cd | cd.getIdentifier() = decl | exists(cd.getDecorator(_)))
}

/**
 * Holds if this is the name of an enum member.
 */
predicate isEnumMember(VarDecl decl) { decl = any(EnumMember member).getIdentifier() }

/**
 * Gets a description of the declaration `vd`, which is either of the form
 * "function f", "variable v" or "class c".
 */
string describeVarDecl(VarDecl vd) {
  if vd = any(Function f).getIdentifier()
  then result = "function " + vd.getName()
  else
    if vd = any(ClassDefinition c).getIdentifier()
    then result = "class " + vd.getName()
    else result = "variable " + vd.getName()
}

/**
 * An import statement that provides variable declarations.
 */
class ImportVarDeclProvider extends Stmt {
  ImportVarDeclProvider() {
    this instanceof ImportDeclaration or
    this instanceof ImportEqualsDeclaration
  }

  /**
   * Gets a variable declaration of this import.
   */
  VarDecl getAVarDecl() {
    result = this.(ImportDeclaration).getASpecifier().getLocal() or
    result = this.(ImportEqualsDeclaration).getIdentifier()
  }

  /**
   * Gets an unacceptable unused variable declared by this import.
   */
  UnusedLocal getAnUnacceptableUnusedLocal() {
    result = this.getAVarDecl().getVariable() and
    not whitelisted(result)
  }
}

/**
 * Holds if it is acceptable that `v` is unused.
 */
predicate whitelisted(UnusedLocal v) {
  // exclude variables mentioned in JSDoc comments in externs
  mentionedInJSDocComment(v)
  or
  // the attributes in .vue files are not extracted, so we can get false positives in those.
  v.getADeclaration().getFile().getExtension() = "vue"
  or
  // exclude variables used to filter out unwanted properties
  isPropertyFilter(v)
  or
  // exclude imports of React that are implicitly referenced by JSX
  isReactForJsx(v)
  or
  // exclude names that are used as types
  exists(VarDecl vd | v = vd.getVariable() |
    isUsedAsType(vd)
    or
    // exclude names that are used as namespaces from inside a type
    isUsedAsNamespace(vd)
    or
    // exclude decorated functions and classes
    isDecorated(vd)
    or
    // exclude names of enum members; they also define property names
    isEnumMember(vd)
    or
    // ignore ambient declarations - too noisy
    vd.isAmbient()
    or
    // ignore variables in template placeholders, as each placeholder sees a different copy of the variable
    vd.getTopLevel() instanceof Templating::TemplateTopLevel
  )
  or
  exists(Expr eval | eval instanceof DirectEval or eval instanceof GeneratedCodeExpr |
    // eval nearby
    eval.getEnclosingFunction() = v.getADeclaration().getEnclosingFunction() and
    // ... but not on the RHS
    not v.getAnAssignedExpr() = eval
  )
}

/**
 * Holds if `vd` declares an unused variable that does not come from an import statement, as explained by `msg`.
 */
predicate unusedNonImports(VarDecl vd, string msg) {
  exists(UnusedLocal v |
    v = vd.getVariable() and
    msg = "Unused " + describeVarDecl(vd) + "." and
    not vd = any(ImportVarDeclProvider p).getAVarDecl() and
    not whitelisted(v)
  )
}

/**
 * Holds if `provider` declares one or more unused variables, as explained by `msg`.
 */
predicate unusedImports(ImportVarDeclProvider provider, string msg) {
  exists(string imports, string names |
    imports = pluralize("import", count(provider.getAnUnacceptableUnusedLocal())) and
    names = strictconcat(provider.getAnUnacceptableUnusedLocal().getName(), ", ") and
    msg = "Unused " + imports + " " + names + "."
  )
}

from AstNode sel, string msg
where
  (
    unusedNonImports(sel, msg) or
    unusedImports(sel, msg)
  ) and
  // avoid reporting if the definition is unreachable
  sel.getFirstControlFlowNode().getBasicBlock() instanceof ReachableBasicBlock
select sel, msg
