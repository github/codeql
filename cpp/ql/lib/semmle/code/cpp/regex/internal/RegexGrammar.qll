/**
 * Provides flow-independent classification of C++ regular-expression
 * *knobs*: the grammar dialect selected at construction (ECMAScript / POSIX
 * BRE / POSIX ERE) and the mode flags supplied at the `std::basic_regex`
 * construction / `.assign(...)` site (`icase`, `multiline`, etc.).
 *
 * These are properties of the parsed literal itself, not of the dataflow
 * analysis, so they live here rather than in `RegexFlowConfigs.qll`. That
 * lets the parser (`internal/ParseRegExp.qll`) and the tree view
 * (`RegexTreeView.qll`) obtain grammar/flag information without depending
 * on the dataflow libraries.
 *
 * The pattern literal is associated with its construction-site flag
 * argument *syntactically*: the pattern literal is looked for as a
 * descendant of the `basic_regex(...)` or `basic_regex::assign(...)` call's
 * first argument (which covers direct use, implicit conversions, and
 * implicit `std::basic_string(...)` temporaries). This is sufficient in
 * practice - the C++ standard-library regex API expects the pattern to
 * appear at the construction site - and, crucially, does not depend on
 * dataflow.
 */

import cpp
private import semmle.code.cpp.regex.internal.StdRegex

// ---------------------------------------------------------------------------
// Construction-site flag readers (std::regex_constants enum plumbing)
// ---------------------------------------------------------------------------
/**
 * Holds if `ec` is a `std::regex_constants` enum constant with the given
 * unqualified name.
 */
private predicate regexConstantsEnum(EnumConstant ec, string name) {
  ec.hasName(name) and
  ec.getDeclaringEnum().getNamespace().getName() = "regex_constants" and
  ec.getDeclaringEnum().getNamespace().getParentNamespace().getName() = "std"
}

/**
 * Holds if `access` (an expression) is a reference to the `regex_constants`
 * enum constant with the given `name`, possibly through implicit conversions.
 */
private predicate refersToRegexConstant(Expr access, string name) {
  exists(EnumConstantAccess eca | eca = access.getAChild*() or eca = access |
    regexConstantsEnum(eca.getTarget(), name)
  )
}

/**
 * Holds if `flagExpr` (a `syntax_option_type`/`match_flag_type` argument) is
 * a bit-or expression, character constant, or single enum constant that
 * includes the `regex_constants` flag with unqualified `name`.
 * This handles both direct use (`std::regex_constants::icase`) and bitwise-OR
 * combinations (`std::regex_constants::icase | std::regex_constants::multiline`).
 */
private predicate containsRegexFlag(Expr flagExpr, string name) {
  refersToRegexConstant(flagExpr, name)
  or
  // Bitwise-OR combination: recurse into both operands.
  containsRegexFlag(flagExpr.(BitwiseOrExpr).getAnOperand(), name)
  or
  // Operator| overload on the flag enum (some libc++ implementations expose
  // `operator|` as a free function). Recurse into arguments.
  exists(FunctionCall fc |
    fc = flagExpr and
    fc.getTarget().hasName("operator|")
  |
    containsRegexFlag(fc.getAnArgument(), name)
  )
}

/**
 * Holds if `regex` appears (as itself or as a descendant of) the pattern
 * argument `patternArg`. This is the flow-free counterpart to "the string
 * literal flows to this pattern-argument node": any implicit conversion
 * chain or wrapping `std::basic_string` temporary constructed around the
 * literal is walked over via `getAChild*`.
 */
private predicate isPatternLiteralOf(StringLiteral regex, Expr patternArg) {
  regex = patternArg.getAChild*()
}

/**
 * Gets a flag argument (`syntax_option_type` / `match_flag_type`) for the
 * `basic_regex` construction (or `assign(...)`) whose pattern is `regex`.
 * Returns nothing if no explicit flag argument is supplied.
 *
 * This association is purely syntactic (no dataflow): the pattern literal
 * must appear inside the constructor/assign call's first argument.
 */
private Expr getConstructionFlagArg(StringLiteral regex) {
  // basic_regex(pattern, flags) constructor - both named-variable and
  // temporary constructions are covered because the search for `regex`
  // is done syntactically inside the constructor's first argument.
  exists(ConstructorCall cc |
    cc.getTarget().getDeclaringType() instanceof StdBasicRegex and
    isPatternLiteralOf(regex, cc.getArgument(0)) and
    result = cc.getArgument(1)
  )
  or
  // basic_regex::assign(pattern, flags).
  exists(FunctionCall fc |
    fc.getTarget().(MemberFunction).getDeclaringType() instanceof StdBasicRegex and
    fc.getTarget().hasName("assign") and
    isPatternLiteralOf(regex, fc.getArgument(0)) and
    result = fc.getArgument(1)
  )
}

/**
 * Holds if `regex` is constructed with the `std::regex_constants::icase` flag,
 * either directly or as part of a bitwise-OR combination.
 */
predicate hasIgnoreCaseFlag(StringLiteral regex) {
  containsRegexFlag(getConstructionFlagArg(regex), "icase")
}

/**
 * Holds if `regex` is constructed with the `std::regex_constants::multiline`
 * flag (C++17 and later), either directly or as part of a bitwise-OR
 * combination.
 */
predicate hasMultilineFlag(StringLiteral regex) {
  containsRegexFlag(getConstructionFlagArg(regex), "multiline")
}

/**
 * Holds if `regex` is constructed with an explicit non-ECMAScript grammar
 * flag (`basic`, `extended`, `awk`, `grep`, or `egrep`).
 *
 * This predicate is purely informational: nothing is excluded from analysis
 * by grammar anymore, since every grammar the standard defines now has a
 * concrete parser subclass (`EcmaRegExp`, `EreRegExp`, `BreRegExp`).
 */
predicate hasNonEcmaScriptGrammarFlag(StringLiteral regex) {
  exists(string g | g = ["basic", "extended", "awk", "grep", "egrep"] |
    containsRegexFlag(getConstructionFlagArg(regex), g)
  )
}

/**
 * Holds if `regex` is constructed with an explicit ECMAScript grammar flag.
 * This is the default grammar of `std::regex` and is handled by
 * `EcmaRegExp`.
 */
predicate hasEcmaScriptGrammarFlag(StringLiteral regex) {
  containsRegexFlag(getConstructionFlagArg(regex), "ECMAScript")
}

/**
 * Holds if `regex` is constructed with a POSIX tool-style grammar flag
 * (`awk`, `grep`, or `egrep`) that we treat as linear-time / non-backtracking.
 */
predicate hasNonBacktrackingGrammarFlag(StringLiteral regex) {
  containsRegexFlag(getConstructionFlagArg(regex), ["awk", "grep", "egrep"])
}

// ---------------------------------------------------------------------------
// Grammar classification
// ---------------------------------------------------------------------------
/**
 * The `std::regex` grammar dialects that the C++ regex parser is aware of.
 *
 * - `Ecma()`  - ECMAScript, the default grammar used by `std::regex`.
 *              Selected either implicitly (no explicit grammar flag) or
 *              explicitly via `std::regex_constants::ECMAScript`. Modeled
 *              by `EcmaRegExp`.
 * - `Bre()`   - POSIX Basic Regular Expressions (selected via the `basic`
 *              or `grep` flags). Modeled by `BreRegExp`.
 * - `Ere()`   - POSIX Extended Regular Expressions (selected via the
 *              `extended`, `egrep`, or `awk` flags). Modeled by
 *              `EreRegExp`.
 *
 * All three cases are exercised by the parser today; every grammar has a
 * concrete subclass, so `hasConcreteGrammar` holds for every regex the
 * parser sees.
 */
newtype TRegexGrammar =
  /** The ECMAScript grammar (the default for `std::regex`), modeled by `EcmaRegExp`. */
  Ecma() or
  /** The POSIX Basic Regular Expression grammar (`basic`/`grep` flags), modeled by `BreRegExp`. */
  Bre() or
  /** The POSIX Extended Regular Expression grammar (`extended`/`egrep`/`awk` flags), modeled by `EreRegExp`. */
  Ere()

/**
 * Gets the `std::regex` grammar dialect of `regex`, inferred from its
 * construction-site `syntax_option_type` flag argument (if any).
 *
 * The mapping is:
 *   - `basic` / `grep`              -> `Bre()`
 *   - `extended` / `egrep` / `awk`  -> `Ere()`
 *   - anything else (default, explicit `ECMAScript`, or unresolved) -> `Ecma()`
 *
 * Every case now has a concrete parser subclass, so `hasConcreteGrammar`
 * holds for the result of this predicate.
 */
TRegexGrammar regexGrammar(StringLiteral regex) {
  if containsRegexFlag(getConstructionFlagArg(regex), ["basic", "grep"])
  then result = Bre()
  else
    if containsRegexFlag(getConstructionFlagArg(regex), ["extended", "egrep", "awk"])
    then result = Ere()
    else result = Ecma()
}

/**
 * Holds if `grammar` has a concrete `RegExp` subclass and can therefore be
 * admitted by the parser's characteristic predicate. All three grammars
 * (`Ecma()`, `Ere()`, `Bre()`) are modeled today, so this holds for every
 * grammar the standard defines. Kept as a helper so that any future grammar
 * scaffolding can be admitted by adding a single disjunct here.
 */
predicate hasConcreteGrammar(TRegexGrammar grammar) {
  grammar = Ecma() or grammar = Ere() or grammar = Bre()
}
