/**
 * Provides classes for working with JSLint/JSHint directives.
 */

import javascript

/** Gets the name of the directive represented by `c`. */
private string getDirectiveName(SlashStarComment c) {
  result = c.getText().regexpCapture("(?s)\\s*(\\w+)\\b.*", 1)
}

/** Gets a function at the specified location. */
private Function getFunctionAt(
  string filepath, int startline, int startcolumn, int endline, int endcolumn
) {
  result.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
}

/** A JSLint directive. */
abstract class JSLintDirective extends SlashStarComment {
  /**
   * Gets the content of this directive, not including the directive name itself,
   * and with end-of-line characters replaced by spaces.
   */
  string getContent() {
    result =
      getText().regexpReplaceAll("[\\n\\r\\u2028\\u2029]", " ").regexpCapture("\\s*\\w+ (.*)", 1)
  }

  /**
   * Gets the name of this directive.
   *
   * Like JSHint (but unlike JSLint), this predicate allows whitespace before the
   * directive name.
   */
  string getName() { result = getDirectiveName(this) }

  /**
   * Gets the function surrounding this directive, if any.
   */
  private Function getASurroundingFunction() {
    exists(string path, int fsl, int fsc, int fel, int fec, int dsl, int dsc, int del, int dec |
      result = getFunctionAt(path, fsl, fsc, fel, fec) and
      this.getLocation().hasLocationInfo(path, dsl, dsc, del, dec)
    |
      // the function starts before this directive
      (
        fsl < dsl
        or
        fsl = dsl and fsc <= dsc
      ) and
      // and it ends after this directive
      (
        del < fel
        or
        del = fel and dec <= fec
      )
    )
  }

  /**
   * Gets the scope of this directive, which is either the closest enclosing
   * function, or the toplevel.
   */
  StmtContainer getScope() {
    result = getASurroundingFunction() and
    not getASurroundingFunction().getEnclosingContainer+() = result
    or
    not exists(getASurroundingFunction()) and result = getTopLevel()
  }

  /**
   * Holds if this directive sets flag `name` to `value`.
   *
   * If a flag is set without providing an explicit value, `value`
   * is the empty string.
   */
  predicate definesFlag(string name, string value) {
    exists(string defn | defn = getContent().splitAt(",").trim() |
      if defn.matches("%:%")
      then (
        name = defn.splitAt(":", 0).trim() and
        value = defn.splitAt(":", 1).trim()
      ) else (
        name = defn and
        value = ""
      )
    )
  }

  /**
   * Holds if this directive applies to statement or expression `s`, meaning that
   * `s` is nested in the directive's scope.
   */
  predicate appliesTo(ExprOrStmt s) {
    exists(StmtContainer sc | sc = s.(Stmt).getContainer() or sc = s.(Expr).getContainer() |
      getScope() = sc.getEnclosingContainer*()
    )
  }
}

/**
 * A JSLint directive declaring global variables.
 *
 * This is either an explicit `global` directive, or a `jslint` directive that implicitly
 * declares a group of related global variables.
 */
abstract class JSLintGlobal extends Linting::GlobalDeclaration, JSLintDirective {
  override predicate appliesTo(ExprOrStmt s) { JSLintDirective.super.appliesTo(s) }

  override predicate declaresGlobalForAccess(GlobalVarAccess gva) {
    declaresGlobal(gva.getName(), _) and
    getScope() = gva.getContainer().getEnclosingContainer*()
  }
}

/** A JSLint `global` directive. */
class JSLintExplicitGlobal extends JSLintGlobal {
  JSLintExplicitGlobal() { getDirectiveName(this) = "global" }

  override predicate declaresGlobal(string name, boolean writable) {
    exists(string value | definesFlag(name, value) |
      writable = true and value = "true"
      or
      writable = false and
      (value = "false" or value = "")
    )
  }
}

/** A JSLint `properties` directive. */
class JSLintProperties extends JSLintDirective {
  JSLintProperties() {
    exists(string name | name = getDirectiveName(this) |
      name = "property" or name = "properties" or name = "members"
    )
  }

  /**
   * Gets a property declared by this directive.
   */
  string getAProperty() { result = getContent().splitAt(",").trim() }
}

/** A JSLint options directive. */
class JSLintOptions extends JSLintDirective {
  JSLintOptions() { getDirectiveName(this) = "jslint" }
}

/**
 * Gets an implicit JSLint global of the given `category`.
 */
private string jsLintImplicitGlobal(string category) {
  // cf. http://www.jslint.com/help.html#global
  category = "browser" and
  (
    result = "clearInterval" or
    result = "clearTimeout" or
    result = "document" or
    result = "event" or
    result = "frames" or
    result = "history" or
    result = "Image" or
    result = "location" or
    result = "name" or
    result = "navigator" or
    result = "Option" or
    result = "parent" or
    result = "screen" or
    result = "setInterval" or
    result = "setTimeout" or
    result = "window" or
    result = "XMLHttpRequest"
  )
  or
  category = "devel" and
  (
    result = "alert" or
    result = "confirm" or
    result = "console" or
    result = "Debug" or
    result = "opera" or
    result = "prompt" or
    result = "WSH"
  )
  or
  category = "node" and
  (
    result = "Buffer" or
    result = "clearInterval" or
    result = "clearTimeout" or
    result = "console" or
    result = "exports" or
    result = "result" or
    result = "module" or
    result = "process" or
    result = "querystring" or
    result = "require" or
    result = "setInterval" or
    result = "setTimeout" or
    result = "__filename" or
    result = "__dirname"
  )
  or
  category = "couch" and
  (
    result = "emit" or
    result = "getRow" or
    result = "isArray" or
    result = "log" or
    result = "provides" or
    result = "registerType" or
    result = "require" or
    result = "send" or
    result = "start" or
    result = "sum" or
    result = "toJSON"
  )
  or
  category = "rhino" and
  (
    result = "defineClass" or
    result = "deserialize" or
    result = "gc" or
    result = "help" or
    result = "load" or
    result = "loadClass" or
    result = "print" or
    result = "quit" or
    result = "readFile" or
    result = "readUrl" or
    result = "runCommand" or
    result = "seal" or
    result = "serialize" or
    result = "spawn" or
    result = "sync" or
    result = "toint32" or
    result = "version"
  )
}

/**
 * A JSLint options directive implicitly declaring a group of globals.
 */
private class JSLintImplicitGlobal extends JSLintOptions, JSLintGlobal {
  JSLintImplicitGlobal() {
    exists(string category |
      definesFlag(category, "true") and
      exists(jsLintImplicitGlobal(category))
    )
  }

  override predicate declaresGlobal(string name, boolean writable) {
    writable = false and
    exists(string category |
      definesFlag(category, "true") and
      name = jsLintImplicitGlobal(category)
    )
  }
}
