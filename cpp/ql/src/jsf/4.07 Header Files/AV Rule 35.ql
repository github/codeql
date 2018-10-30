/**
 * @name Missing header guard
 * @description Header files should contain header guards (#defines to prevent
 *              the file from being included twice). This prevents errors and
 *              inefficiencies caused by repeated inclusion.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/missing-header-guard
 * @tags efficiency
 *       maintainability
 *       modularity
 */
import cpp
import semmle.code.cpp.headers.MultipleInclusion

string possibleGuard(HeaderFile hf, string body) {
  exists(Macro m | m.getFile() = hf and m.getBody() = body | result = m.getHead())
}

/**
 * Option type for preprocessor directives so we can produce a variable number
 * of links in the result
 */
newtype TMaybePreprocessorDirective =
  TSomePreprocessorDirective(PreprocessorDirective pd) or
  TNoPreprocessorDirective()

abstract class MaybePreprocessorDirective extends TMaybePreprocessorDirective {
  abstract string toString();
  abstract Location getLocation();
}

class NoPreprocessorDirective extends TNoPreprocessorDirective, MaybePreprocessorDirective {
  override string toString() {
    result = ""
  }
  
  override Location getLocation() {
    result instanceof UnknownDefaultLocation
  }
}

class SomePreprocessorDirective extends TSomePreprocessorDirective, MaybePreprocessorDirective {
  PreprocessorDirective pd;

  SomePreprocessorDirective() {
    this = TSomePreprocessorDirective(pd)
  }

  override string toString() {
    result = pd.toString()
  }
  
  override Location getLocation() {
    result = pd.getLocation()
  }
  
  PreprocessorDirective getPreprocessorDirective() {
    result = pd
  }
}

/**
 * Provides additional detail when there is an incorrect header guard.
 * The second and third parameters are option typed, and are only present
 * when there are additional links in the detail string.
 */
string extraDetail(HeaderFile hf, SomePreprocessorDirective detail1, SomePreprocessorDirective detail2) {
  exists(string s, PreprocessorEndif endif, PreprocessorDirective ifndef | startsWithIfndef(hf, ifndef, s) and endif.getIf() = ifndef |
    detail1.getPreprocessorDirective() = endif and
    detail2.getPreprocessorDirective() = ifndef and
    if not endsWithEndif(hf, endif) then
      result = " ($@ matching $@ occurs before the end of the file)."
    else if exists(Macro m | m.getFile() = hf and m.getHead() = s) then
      result = " (#define " + s + " needs to appear immediately after #ifndef " + s + ")."
    else if strictcount(possibleGuard(hf, _)) = 1 then
      result = " (" + possibleGuard(hf, _) + " should appear in the #ifndef rather than " + s + ")."
    else if strictcount(possibleGuard(hf, "")) = 1 then
      result = " (" + possibleGuard(hf, "") + " should appear in the #ifndef rather than " + s + ")."
    else
      result = " (the macro " + s + " is checked for, but is not defined)."
  )
}

/**
 * Header file `hf` uses a macro called `macroName`.
 */
predicate usesMacro(HeaderFile hf, string macroName) {
  exists(MacroAccess ma |
    ma.getFile() = hf and
    ma.getMacro().getName() = macroName
  )
}

/**
 * File `f` both defines and un-defines a macro called `macroName`.
 */
predicate defUndef(File f, string macroName) {
  exists(Macro m |
    m.getFile() = f and
    m.getName() = macroName
  ) and exists(PreprocessorUndef ud |
    ud.getFile() = f and
    ud.getName() = macroName
  )
}

/**
 * Header file `hf` looks like it contains an x-macro.
 * That is, a macro that is used to interpret the
 * data in `hf`, usually defined just before including that file
 * and undefined immediately afterwards.
 */
predicate hasXMacro(HeaderFile hf) {
  exists(string macroName |
    usesMacro(hf, macroName) and
    forex(File f | f.getAnIncludedFile() = hf |
      defUndef(f, macroName)
    )
  )
}

from HeaderFile hf, string detail, MaybePreprocessorDirective detail1, MaybePreprocessorDirective detail2
where not hf instanceof IncludeGuardedHeader
  and (if exists(extraDetail(hf, _, _))
    then detail = extraDetail(hf, detail1, detail2)
    else (detail = "." and
      detail1 instanceof NoPreprocessorDirective and
      detail2 instanceof NoPreprocessorDirective))
  // Exclude files which contain no declaration entries or top level
  // declarations (e.g. just preprocessor directives; or non-top level
  // code).
  and (
    exists(DeclarationEntry de | de.getFile() = hf) or
    exists(Declaration d | d.getFile() = hf and d.isTopLevel()) or
    exists(UsingEntry ue | ue.getFile() = hf)
  )
  // Exclude files which look like they contain 'x-macros'
  and not hasXMacro(hf)
  // Exclude files which are always #imported.
  and not forex(Include i | i.getIncludedFile() = hf | i instanceof Import)
  // Exclude files which are only included once.
  and not strictcount(Include i | i.getIncludedFile() = hf) = 1
select hf, "This header file should contain a header guard to prevent multiple inclusion" + detail, detail1, detail1.toString(), detail2, detail2.toString()
