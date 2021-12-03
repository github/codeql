/**
 * Provides classes and predicates related to jump-to-definition links
 * in the code viewer.
 */

import cpp
import IDEContextual

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
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  pragma[noopt]
  final predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    interestingElement(this) and
    not this instanceof MacroAccess and
    not this instanceof Include and
    exists(Location l |
      l = this.getLocation() and
      l.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    )
    or
    // This has a location that covers only the name of the accessed
    // macro, not its arguments (which are included by `MacroAccess`'s
    // `getLocation()`).
    exists(Location l, MacroAccess ma |
      ma instanceof MacroAccess and
      ma = this and
      l = ma.getLocation() and
      l.hasLocationInfo(filepath, startline, startcolumn, _, _) and
      endline = startline and
      exists(string macroName, int nameLength, int nameLengthMinusOne |
        macroName = ma.getMacroName() and
        nameLength = macroName.length() and
        nameLengthMinusOne = nameLength - 1 and
        endcolumn = startcolumn + nameLengthMinusOne
      )
    )
    or
    hasLocationInfo_Include(this, filepath, startline, startcolumn, endline, endcolumn)
  }
}

/**
 * An `Include` with a `hasLocationInfo` predicate.
 *
 * This has a location that covers only the name of the included
 * file, not the `#include` text or whitespace before it.
 */
predicate hasLocationInfo_Include(Include i, string path, int sl, int sc, int el, int ec) {
  exists(Location l |
    l = i.getLocation() and
    path = l.getFile().getAbsolutePath() and
    sl = l.getEndLine() and
    sc = l.getEndColumn() + 1 - i.getIncludeText().length() and
    el = l.getEndLine() and
    ec = l.getEndColumn()
  )
}

/** Holds if `e` is a source or a target of jump-to-definition. */
predicate interestingElement(Element e) {
  exists(definitionOf(e, _))
  or
  e = definitionOf(_, _)
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
cached
private predicate constructorCallTypeMention(ConstructorCall cc, TypeMention tm) {
  exists(File f, int line, int column |
    constructorCallStartLoc(cc, f, line, column) and
    typeMentionStartLoc(tm, _, f, line, column)
  )
}

/**
 * Gets an element, of kind `kind`, that element `e` uses, if any.
 * Attention: This predicate yields multiple definitions for a single location.
 *
 * The `kind` is a string representing what kind of use it is:
 *  - `"M"` for function and method calls
 *  - `"T"` for uses of types
 *  - `"V"` for variable accesses
 *  - `"X"` for macro accesses
 *  - `"I"` for import / include directives
 */
cached
Top definitionOf(Top e, string kind) {
  (
    // call -> function called
    kind = "M" and
    result = e.(Call).getTarget() and
    not e.(Expr).isCompilerGenerated() and
    not e instanceof ConstructorCall // handled elsewhere
    or
    // access -> function, variable or enum constant accessed
    kind = "V" and
    result = e.(Access).getTarget() and
    not e.(Expr).isCompilerGenerated()
    or
    // macro access -> macro accessed
    kind = "X" and
    result = e.(MacroAccess).getMacro()
    or
    // type mention -> type
    kind = "T" and
    e.(TypeMention).getMentionedType() = result and
    not constructorCallTypeMention(_, e) and // handled elsewhere
    // Multiple type mentions can be generated when a typedef is used, and
    // in such cases we want to exclude all but the originating typedef.
    not exists(Type secondary |
      exists(TypeMention tm, File f, int startline, int startcol |
        typeMentionStartLoc(e, result, f, startline, startcol) and
        typeMentionStartLoc(tm, secondary, f, startline, startcol) and
        (
          result = secondary.(TypedefType).getBaseType() or
          result = secondary.(TypedefType).getBaseType().(SpecifiedType).getBaseType()
        )
      )
    )
    or
    // constructor call -> function called
    //  - but only if there is a corresponding type mention, since
    //    we don't want links for implicit conversions.
    //  - using the location of the type mention, since it's
    //    tighter that the location of the function call.
    kind = "M" and
    exists(ConstructorCall cc |
      constructorCallTypeMention(cc, e) and
      result = cc.getTarget()
    )
    or
    // include -> included file
    kind = "I" and
    result = e.(Include).getIncludedFile() and
    // exclude `#include` directives containing macros
    not exists(MacroInvocation mi, Location l1, Location l2 |
      l1 = e.(Include).getLocation() and
      l2 = mi.getLocation() and
      l1.getContainer() = l2.getContainer() and
      l1.getStartLine() = l2.getStartLine()
      // (an #include directive must be always on it's own line)
    )
  ) and
  (
    // exclude things inside macro invocations, as they will overlap
    // with the macro invocation.
    not e.(Element).isInMacroExpansion() and
    // exclude nested macro invocations, as they will overlap with
    // the top macro invocation.
    not exists(e.(MacroAccess).getParentInvocation())
  ) and
  // Some entities have many locations. This can arise for an external
  // function that is frequently declared but not defined, or perhaps
  // for a struct type that is declared in many places. Rather than
  // letting the result set explode, we just exclude results that are
  // "too ambiguous" -- we could also arbitrarily pick one location
  // later on.
  strictcount(result.getLocation()) < 10
}
