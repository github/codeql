import cpp

/**
 * A macro. For example, the macro `MYMACRO` in the following code:
 * ```
 * #define MYMACRO 1
 * ```
 */
class Macro extends PreprocessorDirective, @ppd_define {
  /**
   * Gets the head of this macro. For example, `MAX(x,y)` in
   * `#define MAX(x,y) (((x)>(y))?(x):(y))`.
   */
  override string getHead() { preproctext(underlyingElement(this), result, _) }

  override string getAPrimaryQlClass() { result = "Macro" }

  /**
   * Gets the body of this macro. For example, `(((x)>(y))?(x):(y))` in
   * `#define MAX(x,y) (((x)>(y))?(x):(y))`.
   */
  string getBody() { preproctext(underlyingElement(this), _, result) }

  /** Gets an invocation of this macro. */
  MacroInvocation getAnInvocation() { result.getMacro() = this }

  override string toString() {
    if this.getBody() = ""
    then result = "#define " + this.getHead()
    else result = "#define " + this.getHead() + " " + this.getBody()
  }

  /**
   * Gets the name of the macro.  For example, `MAX` in
   * `#define MAX(x,y) (((x)>(y))?(x):(y))`.
   */
  string getName() { result = this.getHead().regexpCapture("([^(]*+).*", 1) }

  /** Holds if the macro has name `name`. */
  predicate hasName(string name) { this.getName() = name }
}

/**
 * A macro access.  For example:
 * ```
 * #ifdef MACRO1     // this line contains a MacroAccess
 *   int x = MACRO2; // this line contains a MacroAccess
 * #endif
 * ```
 *
 * See also `MacroInvocation`, which represents only macro accesses
 * that are expanded (such as in the second line of the example above).
 */
class MacroAccess extends Locatable, @macroinvocation {
  /** Gets the macro that is being accessed. */
  Macro getMacro() { macroinvocations(underlyingElement(this), unresolveElement(result), _, _) }

  /**
   * Gets the location of the outermost macro access that triggered this macro
   * access. This is equivalent to calling
   * `this.getOutermostMacroAccess().getActualLocation()`. For example, the
   * location of the invocation of `C` in `P(C)` will be the whole source range
   * starting with `P` and ending with `)`.
   */
  override Location getLocation() { result = this.getOutermostMacroAccess().getActualLocation() }

  override string getAPrimaryQlClass() { result = "MacroAccess" }

  /**
   * Gets the location of this macro access. For a nested access, where
   * `exists(this.getParentInvocation())`, this yields a location either inside
   * a `#define` directive or inside an argument to another macro.
   */
  Location getActualLocation() { macroinvocations(underlyingElement(this), _, result, _) }

  /**
   * Gets the parent macro invocation, if any. For example:
   *
   * ```
   * 1:  #define C 0
   * 2:  #define P C
   * 3:  static int x = P;
   * ```
   *
   * The invocation of `P` on line 3 also invokes `C`. The invocation of
   * `P` is the parent of the invocation of `C`.
   *
   * A macro invocation occurring in a macro argument often also establishes a
   * parent relationship. This is due to the "call-by-name" evaluation order of
   * C macros, where macro arguments are first substituted textually into the
   * macro body before macro expansion is again performed on the body, invoking
   * the macros present in the original macro argument. For example:
   *
   * ```
   * 1:  #define C 0
   * 2:  #define P(c)  c + c
   * 3:  static int x = P(C);
   * ```
   *
   * In this case, `P(C)` first expands to `C + C`, which triggers an
   * invocation of `C` whose parent is the invocation of `P`. Had `c` not
   * occurred in the body of `P`, there would have been no invocation of `C`.
   * There is only a single invocation even though `c` occurs twice; this is an
   * optimization for efficiency.
   */
  MacroInvocation getParentInvocation() {
    macroparent(underlyingElement(this), unresolveElement(result))
  }

  /**
   * Gets the outermost `MacroAccess` along the chain of `getParentInvocation`.
   * If `this` has no parent, the result will be `this` itself.
   */
  MacroAccess getOutermostMacroAccess() {
    if not exists(this.getParentInvocation())
    then result = this
    else result = this.getParentInvocation().getOutermostMacroAccess()
  }

  override string toString() { result = this.getMacro().getHead() }

  /** Gets the name of the accessed macro. */
  string getMacroName() { result = this.getMacro().getName() }
}

/**
 * A macro invocation (macro access that is expanded).  For example:
 * ```
 * #ifdef MACRO1
 *   int x = MACRO2; // this line contains a MacroInvocation
 * #endif
 * ```
 *
 * See also `MacroAccess`, which also represents macro accesses where the macro
 * is checked but not expanded (such as in the first line of the example above).
 */
class MacroInvocation extends MacroAccess {
  MacroInvocation() { macroinvocations(underlyingElement(this), _, _, 1) }

  override string getAPrimaryQlClass() { result = "MacroInvocation" }

  /**
   * Gets an element that occurs in this macro invocation or a nested macro
   * invocation.
   */
  Locatable getAnExpandedElement() {
    inmacroexpansion(unresolveElement(result), underlyingElement(this))
  }

  /**
   * Gets an element that is (partially) affected by a macro
   * invocation. This is a superset of the set of expanded elements and
   * includes elements that are not completely enclosed by the expansion as
   * well.
   */
  Locatable getAnAffectedElement() {
    inmacroexpansion(unresolveElement(result), underlyingElement(this)) or
    macrolocationbind(underlyingElement(this), result.getLocation())
  }

  /**
   * Gets an element that is either completely in the macro expansion, or
   * (if it is a statement) 'almost' in the macro expansion (for instance
   * up to a trailing semicolon). Useful for common patterns in which
   * macros are almost syntactically complete elements but not quite.
   */
  Locatable getAGeneratedElement() {
    result = this.getAnExpandedElement() or
    result.(Stmt).getGeneratingMacro() = this
  }

  /**
   * Gets a function that includes an expression that is affected by this macro
   * invocation. If the macro expansion includes the end of one function and
   * the beginning of another, this predicate will get both.
   */
  Function getEnclosingFunction() {
    result = this.getAnAffectedElement().(Expr).getEnclosingFunction()
  }

  /**
   * Gets a top-level expression associated with this macro invocation,
   * if any. Note that this predicate will fail if the top-level expanded
   * element is not an expression (for example if it is a statement).
   *
   * This macro is intended to be used with macros that expand to a complete
   * expression. In other cases, it may have multiple results or no results.
   */
  Expr getExpr() {
    result = this.getAnExpandedElement() and
    not result.getParent() = this.getAnExpandedElement() and
    not result instanceof Conversion
  }

  /**
   * Gets the top-level statement associated with this macro invocation, if
   * any. Note that this predicate will fail if the top-level expanded
   * element is not a statement (for example if it is an expression).
   */
  Stmt getStmt() {
    result = this.getAnExpandedElement() and
    not result.getParent() = this.getAnExpandedElement()
  }

  /**
   * Gets the `i`th _unexpanded_ argument of this macro invocation, where the
   * first argument has `i = 0`. The result has been expanded for macro
   * parameters but _not_ for macro invocations. This means that for macro
   * invocations not inside a `#define`, which can have no macro parameters in
   * their arguments, the result is equivalent to what is in the source text,
   * modulo whitespace.
   *
   * In the following code example, the argument of the outermost invocation is
   * `ID(1)` in unexpanded form and `1` in expanded form.
   *
   * ```
   * #define ID(x) x
   * ID(ID(1))
   * ```
   *
   * In the following example code, the last line contains an invocation of
   * macro `A` and a child invocation of macro `ID`. The argument to `ID` is
   * `1` in both unexpanded and expanded form because macro parameters (here,
   * `x`) are expanded in both cases.
   *
   * ```
   * #define ID(x) x
   * #define A(x) ID(x)
   * A(1)
   * ```
   *
   * The `...` parameter in variadic macros counts as one parameter that always
   * receives one argument, which may contain commas.
   *
   * Use `getExpandedArgument` to get the expanded form.
   */
  string getUnexpandedArgument(int i) {
    macro_argument_unexpanded(underlyingElement(this), i, result)
  }

  /**
   * Gets the `i`th _expanded_ argument of this macro invocation, where the
   * first argument has `i = 0`. The result has been expanded for macros _and_
   * macro parameters. If the macro definition does not use this argument, the
   * extractor will avoid computing the expanded form for efficiency, and the
   * result will be "".
   *
   * See the documentation of `getUnexpandedArgument` for examples of the
   * differences between expanded and unexpanded arguments.
   */
  string getExpandedArgument(int i) { macro_argument_expanded(underlyingElement(this), i, result) }
}

/** Holds if `l` is the location of a macro. */
predicate macroLocation(Location l) { macrolocationbind(_, l) }

/** Holds if `element` is in the expansion of a macro. */
predicate inMacroExpansion(Locatable element) {
  inmacroexpansion(unresolveElement(element), _)
  or
  macroLocation(element.getLocation()) and
  not topLevelMacroAccess(element)
}

/**
 * Holds if `ma` is a `MacroAccess` that is not nested inside another
 * macro invocation.
 */
private predicate topLevelMacroAccess(MacroAccess ma) { not exists(ma.getParentInvocation()) }

/**
 * Holds if `element` is in the expansion of a macro from
 * a system header.
 */
predicate inSystemMacroExpansion(Locatable element) {
  exists(MacroInvocation m |
    element = m.getAnExpandedElement() and
    not exists(m.getMacro().getLocation().getFile().getRelativePath())
  )
}

/** Holds if `element` is affected by a macro. */
predicate affectedByMacro(Locatable element) {
  inMacroExpansion(element) or
  affectedbymacroexpansion(unresolveElement(element), _)
}

/** Holds if there is a macro invocation on line `line` of file `f`. */
predicate macroLine(File f, int line) {
  exists(MacroInvocation mi, Location l |
    l = mi.getLocation() and
    l.getFile() = f and
    (l.getStartLine() = line or l.getEndLine() = line)
  )
}

/** Holds if there might be a macro invocation at location `l`. */
predicate possibleMacroLocation(Location l) {
  macroLine(l.getFile(), l.getStartLine()) or
  macroLine(l.getFile(), l.getEndLine())
}
