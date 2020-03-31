/**
 * Provides definitions related to _include guards_: techniques for preventing
 * multiple inclusion of header files.
 */

import cpp

/**
 * A header file with an include guard.
 */
abstract class IncludeGuardedHeader extends HeaderFile { }

/**
 * A header file that uses a non-portable mechanism to prevent multiple
 * inclusion.
 */
abstract class BadIncludeGuard extends IncludeGuardedHeader {
  /** Gets the element to blame for this bad include guard pattern. */
  abstract Element blame();
}

/**
 * A header file with the correct include guard: `#ifndef` (or equivalent),
 * `#define`, and `#endif`.
 */
class CorrectIncludeGuard extends IncludeGuardedHeader {
  CorrectIncludeGuard() { correctIncludeGuard(this, _, _, _, _) }

  /** Gets the name of the preprocessor define used to prevent multiple inclusion of this file. */
  string getIncludeGuardName() { correctIncludeGuard(this, _, _, _, result) }

  /** Gets the preprocessor macro used to prevent multiple inclusion of this file. */
  Macro getDefine() { correctIncludeGuard(this, _, result, _, _) }

  /** Gets the `#ifndef` or `#if` directive used to prevent multiple inclusion of this file. */
  PreprocessorDirective getIfndef() { correctIncludeGuard(this, result, _, _, _) }

  /** Gets the `#endif` directive closing this file. */
  PreprocessorEndif getEndif() { correctIncludeGuard(this, _, _, result, _) }
}

/**
 * DEPRECATED: no longer useful.
 */
deprecated class NotIncludedGuard extends IncludeGuardedHeader {
  NotIncludedGuard() { none() }

  /** Gets the `#ifndef` directive used to prevent multiple inclusion of this file. */
  PreprocessorIfndef getIfndef() { result.getFile() = this }

  /** Gets the `#endif` directive closing this file. */
  PreprocessorEndif getEndif() { result.getFile() = this }
}

/**
 * A file with no code in it.
 */
class EmptyFile extends IncludeGuardedHeader {
  EmptyFile() { this.(MetricFile).getNumberOfLinesOfCode() = 0 }
}

private predicate hasMacro(HeaderFile hf, string name, Macro define) {
  define.getFile() = hf and define.getName() = name
}

/**
 * Holds if `hf` begins with an `#ifndef` or `#if` directive `ifndef`, to test
 * the macro named `includeGuard`, and ends with the matching `endif`.
 */
predicate hasIncludeGuard(
  HeaderFile hf, PreprocessorDirective ifndef, PreprocessorEndif endif, string includeGuard
) {
  startsWithIfndef(hf, ifndef, includeGuard) and
  endsWithEndif(hf, endif) and
  endif.getIf() = ifndef
}

/**
 * Holds if `hf` uses a valid include guard with the macro named `includeGuard`
 * and the preprocessor directives `ifndef`, `define`, and `endif`. This
 * analysis is also exposed in an object-oriented style through the class
 * `CorrectIncludeGuard`.
 */
pragma[noopt]
predicate correctIncludeGuard(
  HeaderFile hf, PreprocessorDirective ifndef, Macro define, PreprocessorEndif endif,
  string includeGuard
) {
  hasIncludeGuard(hf, ifndef, endif, includeGuard) and
  hasMacro(hf, includeGuard, define) and
  // we already know the ifndef is first and the endif last, so we just need
  // to check there is nothing before the define that isn't the ifndef.
  not exists(
    int relevant, Location ifndefLocation, int ifndefLine, Location defineLocation, int defineLine
  |
    includeGuardRelevantLine(hf, relevant) and
    ifndefLocation = ifndef.getLocation() and
    ifndefLine = ifndefLocation.getStartLine() and
    relevant != ifndefLine and
    defineLocation = define.getLocation() and
    defineLine = defineLocation.getStartLine() and
    relevant < defineLine
  )
}

/**
 * Holds if `hf` begins with an `#ifndef` or `#if` directive `ifndef`, to test
 * the macro named `macroName`.
 */
predicate startsWithIfndef(HeaderFile hf, PreprocessorDirective ifndef, string macroName) {
  ifndefDirective(ifndef, macroName) and
  exists(Location loc |
    loc = ifndef.getLocation() and
    loc.getFile() = hf and
    loc.getStartLine() = min(int l | includeGuardRelevantLine(hf, l))
  )
}

private predicate endifLocation(PreprocessorEndif endif, File f, int line) {
  endif.getFile() = f and
  endif.getLocation().getStartLine() = line
}

private predicate lastEndifLocation(PreprocessorEndif endif, File f, int line) {
  endifLocation(endif, f, line) and
  line = max(int line2 | endifLocation(_, f, line2))
}

/**
 * Holds if `hf` ends with `endif`.
 */
predicate endsWithEndif(HeaderFile hf, PreprocessorEndif endif) {
  exists(int line | lastEndifLocation(endif, hf, line) |
    line = max(int l | includeGuardRelevantLine(hf, l) | l)
  )
}

private predicate includeGuardRelevantLine(HeaderFile hf, int line) {
  exists(Location l | l.getFile() = hf and line = l.getStartLine() |
    // any declaration
    exists(Declaration d | l = d.getADeclarationLocation())
    or
    // most preprocessor directives
    exists(PreprocessorDirective p |
      l = p.getLocation() and
      // included files may be outside the include guards, as they
      // should contain an include guarding mechanism of their own.
      not p instanceof Include
    )
  )
}

/**
 * Holds if `ppd` is effectively an `#ifndef` directive that tests `macro`.
 * This includes `#if !defined(macro)`.
 */
predicate ifndefDirective(PreprocessorDirective ppd, string macro) {
  ppd instanceof PreprocessorIfndef and macro = ppd.getHead()
  or
  ppd instanceof PreprocessorIf and
  exists(string head | head = ppd.getHead() |
    macro =
      head
          .replaceAll("(", " ")
          .replaceAll(")", "")
          .replaceAll("\t", " ")
          .regexpCapture("[ ]*![ ]*defined[ ]+([^ ]*)[ ]*", 1)
          .trim()
  )
}

/**
 * A header file with the `#pragma once` include guard.
 */
class PragmaOnceIncludeGuard extends BadIncludeGuard {
  PragmaOnceIncludeGuard() {
    exists(PreprocessorPragma p | p.getFile() = this and p.getHead() = "once")
  }

  override Element blame() {
    exists(PreprocessorPragma p | p.getFile() = this and p = result and p.getHead() = "once")
  }
}
