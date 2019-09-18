/**
 * Provides a predicate for identifying uses of features introduced in ECMAScript 2015
 * and later.
 */

import javascript

/**
 * Holds if `nd` is a use of a feature introduced in ECMAScript version `ver`
 * from the given category.
 *
 * Categories are taken from Kangax' [ECMAScript 6 compatibility table]
 * (https://kangax.github.io/compat-table/es6/) and [ECMAScript next compatibility table]
 * (https://kangax.github.io/compat-table/esnext/).
 */
predicate isES20xxFeature(ASTNode nd, int version, string category) {
  version = 2015 and
  (
    exists(nd.(Parameter).getDefault()) and category = "default function parameters"
    or
    exists(Expr e |
      e = nd and
      // synthetic constructors use rest/spread/super, but we don't want to count those
      not e.getEnclosingFunction() instanceof SyntheticConstructor
    |
      nd.(Parameter).isRestParameter() and
      category = "rest parameters"
      or
      nd instanceof SpreadElement and
      // spread properties are an ES2018 feature, see below
      not nd = any(SpreadProperty sp).getInit() and
      category = "spread (...) operator"
      or
      nd instanceof SuperExpr and category = "super"
    )
    or
    exists(Property prop | prop = nd |
      prop.getName() = "__proto__" or
      prop.isShorthand() or
      prop.isMethod() or
      prop.isComputed()
    ) and
    category = "object literal extensions"
    or
    nd instanceof ForOfStmt and category = "for..of loops"
    or
    nd.(Literal).getRawValue().regexpMatch("^0[bo].*") and category = "octal and binary literals"
    or
    nd instanceof TemplateLiteral and category = "template literals"
    or
    exists(RegExpLiteral rel | rel = nd |
      rel.getFlags().regexpMatch(".*[yu].*") and
      category = "RegExp \"y\" and \"u\" flags"
    )
    or
    exists(VariableDeclarator vd | vd = nd |
      vd.getBindingPattern() instanceof DestructuringPattern and
      category = "destructuring declarations"
    )
    or
    exists(AssignExpr assgn | assgn = nd |
      assgn.getLhs().stripParens() instanceof DestructuringPattern and
      category = "destructuring assignment"
    )
    or
    nd.(Parameter) instanceof DestructuringPattern and category = "destructuring parameters"
    or
    exists(StringLiteral sl | sl = nd |
      sl.getRawValue().regexpMatch(".*(?<!\\\\)\\\\u\\{[a-fA-F0-9]+\\}.*") and
      category = "Unicode code point escapes"
    )
    or
    nd instanceof NewTargetExpr and category = "new.target"
    or
    nd instanceof ConstDeclStmt and category = "const"
    or
    nd instanceof LetStmt and category = "let"
    or
    nd instanceof ArrowFunctionExpr and category = "arrow functions"
    or
    nd instanceof ClassDefinition and category = "class"
    or
    nd.(Function).isGenerator() and category = "generators"
    or
    nd instanceof YieldExpr and category = "generators"
    or
    nd instanceof ES2015Module and category = "modules"
  )
  or
  version = 2016 and
  (
    (nd instanceof ExpExpr or nd instanceof AssignExpExpr) and
    category = "exponentiation operator"
  )
  or
  version = 2017 and
  (
    (nd.(Function).hasTrailingComma() or nd.(InvokeExpr).hasTrailingComma()) and
    category = "trailing function comma"
    or
    (nd instanceof AwaitExpr or nd.(Function).isAsync()) and
    category = "async/await"
  )
  or
  version = 2018 and
  (
    nd.(RegExpLiteral).isDotAll() and
    category = "'s' regular expression flag"
    or
    exists(TemplateElement te | te = nd | not te.hasValue()) and
    category = "revised template literal syntax"
    or
    exists(nd.(ObjectPattern).getRest()) and
    category = "rest properties"
    or
    nd instanceof SpreadProperty and
    category = "spread properties"
    or
    (
      nd.(ForOfStmt).isAwait()
      or
      exists(Function f | f = nd | f.isAsync() and f.isGenerator())
    ) and
    category = "asynchronous iteration"
    or
    exists(RegExpTerm ret | ret.getLiteral() = nd |
      (ret.(RegExpGroup).isNamed() or exists(ret.(RegExpBackRef).getName())) and
      category = "named capture groups"
      or
      ret instanceof RegExpLookbehind and
      category = "lookbehind assertions"
      or
      ret instanceof RegExpUnicodePropertyEscape and
      category = "Unicode property escapes"
    )
  )
}
