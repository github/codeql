/**
 * Provides classes and predicates for classifying files as containing
 * generated code, test code, externs declarations, library code or
 * template code.
 */

import semmle.javascript.GeneratedCode
import semmle.javascript.frameworks.Testing
import semmle.javascript.frameworks.Templating
import semmle.javascript.dependencies.FrameworkLibraries

/**
 * Holds if `e` may be caused by parsing a template file as plain HTML or JavaScript.
 *
 * We use two heuristics: check for the presence of a known template delimiter preceding
 * the error on the same line, and check whether the file name contains `template` or
 * `templates`.
 */
predicate maybeCausedByTemplate(JSParseError e) {
  exists(File f | f = e.getFile() |
    e.getLine().indexOf(Templating::getADelimiter()) <= e.getLocation().getStartColumn()
    or
    f.getAbsolutePath().regexpMatch("(?i).*\\btemplates?\\b.*")
  )
}

/**
 * Holds if `e` is an expression in the form `o.p1.p2.p3....pn`.
 */
private predicate isNestedDotExpr(DotExpr e) {
  e.getBase() instanceof VarAccess or
  isNestedDotExpr(e.getBase())
}

/**
 * Holds if `tl` only contains variable declarations and field reads.
 */
private predicate looksLikeExterns(TopLevel tl) {
  forex(Stmt s | s.getParent() = tl |
    exists(VarDeclStmt vds | vds = s |
      forall(VariableDeclarator vd | vd = vds.getADecl() | not exists(vd.getInit()))
    )
    or
    isNestedDotExpr(s.(ExprStmt).getExpr())
  )
}

/**
 * Holds if `f` is classified as belonging to `category`.
 *
 * There are currently four categories:
 *   - `"generated"`: `f` contains generated or minified code;
 *   - `"test"`: `f` contains test code;
 *   - `"externs"`: `f` contains externs declarations;
 *   - `"library"`: `f` contains library code;
 *   - `"template"`: `f` contains template code.
 */
predicate classify(File f, string category) {
  isGenerated(f.getATopLevel()) and category = "generated"
  or
  (
    exists(Test t | t.getFile() = f)
    or
    exists(string stemExt | stemExt = "test" or stemExt = "spec" |
      f = getTestFile(any(File orig), stemExt)
    )
    or
    f.getAbsolutePath().regexpMatch(".*/__(mocks|tests)__/.*")
  ) and
  category = "test"
  or
  (f.getATopLevel().isExterns() or looksLikeExterns(f.getATopLevel())) and
  category = "externs"
  or
  f.getATopLevel() instanceof FrameworkLibraryInstance and category = "library"
  or
  exists(JSParseError err | maybeCausedByTemplate(err) |
    f = err.getFile() and category = "template"
  )
  or
  // Polymer templates
  exists(HTML::Element elt | elt.getName() = "template" |
    f = elt.getFile() and
    category = "template" and
    not f.getExtension() = "vue"
  )
}
