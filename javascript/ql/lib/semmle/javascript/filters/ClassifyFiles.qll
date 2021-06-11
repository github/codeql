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
 * Holds if `f` contains generated or minified code.
 */
predicate isGeneratedCodeFile(File f) { isGenerated(f.getATopLevel()) }

/**
 * Holds if `f` contains test code.
 */
predicate isTestFile(File f) {
  exists(Test t | t.getFile() = f)
  or
  exists(string stemExt | stemExt = "test" or stemExt = "spec" |
    f = getTestFile(any(File orig), stemExt)
  )
  or
  f.getAbsolutePath().regexpMatch(".*/__(mocks|tests)__/.*")
}

/**
 * Holds if `f` contains externs declarations.
 */
predicate isExternsFile(File f) {
  (f.getATopLevel().isExterns() or looksLikeExterns(f.getATopLevel()))
}

/**
 * Holds if `f` contains library code.
 */
predicate isLibaryFile(File f) { f.getATopLevel() instanceof FrameworkLibraryInstance }

/**
 * Holds if `f` contains template code.
 */
predicate isTemplateFile(File f) {
  exists(JSParseError err | maybeCausedByTemplate(err) | f = err.getFile())
  or
  // Polymer templates
  exists(HTML::Element elt | elt.getName() = "template" |
    f = elt.getFile() and
    not f.getExtension() = "vue"
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
pragma[inline]
predicate classify(File f, string category) {
  isGeneratedCodeFile(f) and category = "generated"
  or
  isTestFile(f) and category = "test"
  or
  isExternsFile(f) and category = "externs"
  or
  isLibaryFile(f) and category = "library"
  or
  isTemplateFile(f) and category = "template"
}
