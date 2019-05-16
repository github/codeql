/**
 * Provides classes and predicates related to jump-to-definition links
 * in the code viewer.
 */

import cpp

/**
 * Any element that might be the source or target of a jump-to-definition
 * link.
 *
 * In some cases it is preferable to modify locations (the
 * `hasLocationInfo()` predicate) so that they are short, and
 * non-overlapping with other locations that might be highlighted in
 * the LGTM interface.
 *
 * We need to give locations that may not be in the database, so
 * we use `hasLocationInfo()` rather than `getLocation()`.
 */
class Top extends Element {
  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(string filepath,
                            int startline, int startcolumn,
                            int endline, int endcolumn) {
    exists(Location l | l = this.getLocation()
                    and filepath    = l.getFile().getAbsolutePath()
                    and startline   = l.getStartLine()
                    and startcolumn = l.getStartColumn()
                    and endline     = l.getEndLine()
                    and endcolumn   = l.getEndColumn())
  }
}

/**
 * A `MacroAccess` with a `hasLocationInfo` predicate.
 *
 * This has a location that covers only the name of the accessed
 * macro, not its arguments (which are included by `MacroAccess`'s
 * `getLocation()`).
 */
class MacroAccessWithHasLocationInfo extends Top {
  MacroAccessWithHasLocationInfo() {
    this instanceof MacroAccess
  }

  override
  predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    exists(MacroAccess ma, Location l |
           ma = this
       and l = ma.getLocation()
       and path = l.getFile().getAbsolutePath()
       and sl = l.getStartLine()
       and sc = l.getStartColumn()
       and el = sl
       and ec = sc + ma.getMacroName().length() - 1)
  }
}

/**
 * An `Include` with a `hasLocationInfo` predicate.
 *
 * This has a location that covers only the name of the included
 * file, not the `#include` text or whitespace before it.
 */
class IncludeWithHasLocationInfo extends Top {
  IncludeWithHasLocationInfo() {
    this instanceof Include
  }

  override
  predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    exists(Include i, Location l |
      i = this and
      l = i.getLocation() and
      path = l.getFile().getAbsolutePath() and
      sl = l.getEndLine() and
      sc = l.getEndColumn() + 1 - i.getIncludeText().length() and
      el = l.getEndLine() and
      ec = l.getEndColumn()
    )
  }
}

/**
 * Holds if `f`, `line`, `column` indicate the start character
 * of `cc`. 
 */
private predicate constructorCallStartLoc(ConstructorCall cc, File f, int line, int column) {
  exists(Location l |
    l = cc.getLocation() and
    l.getFile() = f and
    l.getStartLine() = line and
    l.getStartColumn() = column
  )
}

/**
 * Holds if `f`, `line`, `column` indicate the start character
 * of `tm`, which mentions `t`. Type mentions for instantiations
 * are filtered out.
 */
private predicate typeMentionStartLoc(TypeMention tm, Type t, File f, int line, int column) {
  exists(Location l |
    l = tm.getLocation() and
    l.getFile() = f and
    l.getStartLine() = line and
    l.getStartColumn() = column
  ) and
  t = tm.getMentionedType() and
  not t instanceof ClassTemplateInstantiation
}

/**
 * Holds if `cc` and `tm` begin at the same character.
 */
private cached predicate constructorCallTypeMention(ConstructorCall cc, TypeMention tm) {
  exists(File f, int line, int column |
    constructorCallStartLoc(cc, f, line, column) and
    typeMentionStartLoc(tm, _, f, line, column)
  )
}

private predicate definitionOf1(Top e, Top def, string kind) {
  (
    (
      // call -> function called
      kind = "M" and
      def = e.(Call).getTarget() and
      not e.(Expr).isCompilerGenerated() and
      not e instanceof ConstructorCall // handled elsewhere
    ) or (
      // macro access -> macro accessed
      kind = "X" and
      def = e.(MacroAccess).getMacro()
    ) or (
      // type mention -> type
      kind = "T" and
      e.(TypeMention).getMentionedType() = def and
      not constructorCallTypeMention(_, e) and // handled elsewhere
      // Multiple type mentions can be generated when a typedef is used, and
      // in such cases we want to exclude all but the originating typedef.
      not exists(Type secondary |
        exists(TypeMention tm, File f, int startline, int startcol |
          typeMentionStartLoc(e, def, f, startline, startcol) and
          typeMentionStartLoc(tm, secondary, f, startline, startcol) and
          (
            def = secondary.(TypedefType).getBaseType() or
            def = secondary.(TypedefType).getBaseType().(SpecifiedType).getBaseType()
          )
        )
      )
    ) or (
      // constructor call -> function called
      //  - but only if there is a corresponding type mention, since
      //    we don't want links for implicit conversions.
      //  - using the location of the type mention, since it's
      //    tighter that the location of the function call.
      kind = "M" and
      exists(ConstructorCall cc |
        constructorCallTypeMention(cc, e) and
        def = cc.getTarget()
      )
    ) or (
      // include -> included file
      kind = "I" and
      def = e.(Include).getIncludedFile() and

      // exclude `#include` directives containing macros
      not exists(MacroInvocation mi, Location l1, Location l2 |
        l1 = e.(Include).getLocation() and
        l2 = mi.getLocation() and
        l1.getContainer() = l2.getContainer() and
        l1.getStartLine() = l2.getStartLine()
        // (an #include directive must be always on it's own line)
      )
    )
  ) and (
    // exclude things inside macro invocations, as they will overlap
    // with the macro invocation.
    not e.(Element).isInMacroExpansion() and

    // exclude nested macro invocations, as they will overlap with
    // the top macro invocation.
    not exists(e.(MacroAccess).getParentInvocation()) and

    // exclude results from template instantiations, as:
    // (1) these dependencies will often be caused by a choice of
    // template parameter, which is non-local to this part of code; and
    // (2) overlapping results pointing to different locations will
    // be very common.
    // It's possible we could allow a subset of these dependencies
    // in future, if we're careful to ensure the above don't apply.
    not e.isFromTemplateInstantiation(_)
  )
}

private predicate definitionOf2(Top e, Top def, string kind) {
  (
    (
      // access -> function, variable or enum constant accessed
      kind = "V" and
      def = e.(Access).getTarget() and
      not e.(Expr).isCompilerGenerated()
    )
  ) and (
    // exclude things inside macro invocations, as they will overlap
    // with the macro invocation.
    not e.(Element).isInMacroExpansion() and

    // exclude results from template instantiations, as:
    // (1) these dependencies will often be caused by a choice of
    // template parameter, which is non-local to this part of code; and
    // (2) overlapping results pointing to different locations will
    // be very common.
    // It's possible we could allow a subset of these dependencies
    // in future, if we're careful to ensure the above don't apply.
    not e.isFromTemplateInstantiation(_)
  )
}

/**
 * Gets an element, of kind `kind`, that element `e` uses, if any.
 *
 * The `kind` is a string representing what kind of use it is:
 *  - `"M"` for function and method calls
 *  - `"T"` for uses of types
 *  - `"V"` for variable accesses
 *  - `"X"` for macro accesses
 *  - `"I"` for import / include directives
 */
Top definitionOf(Top e, string kind) {
  definitionOf1(e, result, kind) or
  definitionOf2(e, result, kind)
}
