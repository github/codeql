/**
 * Provides classes and predicates for reasoning about C++ standard-library
 * regular-expression usage.
 *
 * This module identifies which `StringLiteral`s flow (via global taint
 * tracking) into a `std::basic_regex` construction or into one of the free
 * matching functions (`std::regex_match`, `std::regex_search`,
 * `std::regex_replace`) or iterators (`std::regex_iterator`,
 * `std::regex_token_iterator`), and detects the construction-site flags of
 * `std::regex_constants::syntax_option_type` and
 * `std::regex_constants::match_flag_type` that affect matching semantics.
 *
 * The `regexMatchedAgainst` predicate mirrors the intent of the Java
 * `RegexFlowConfigs.qll` library.
 *
 * Only ECMAScript-grammar regexes are considered analyzable by the Phase 1
 * parser; literals explicitly constructed with a non-ECMAScript grammar flag
 * (`basic`, `extended`, `awk`, `grep`, `egrep`) are excluded.
 */

import cpp
private import semmle.code.cpp.dataflow.new.DataFlow
private import semmle.code.cpp.dataflow.new.TaintTracking

// ---------------------------------------------------------------------------
// std::basic_regex identification
// ---------------------------------------------------------------------------

/**
 * A `std::basic_regex` class type (or instantiation thereof, e.g. `std::regex`,
 * `std::wregex`).
 */
class StdBasicRegex extends Class {
  StdBasicRegex() {
    this.hasQualifiedName("std", "basic_regex")
    or
    this.(ClassTemplateInstantiation).getTemplate().hasQualifiedName("std", "basic_regex")
  }
}

/**
 * Holds if `t`, after stripping references, const/volatile, and typedefs,
 * denotes a `std::basic_regex` type.
 */
private predicate isBasicRegexType(Type t) {
  exists(Type u | u = t.stripType() |
    u instanceof StdBasicRegex
    or
    // Typedefs (e.g. `std::regex` = `std::basic_regex<char>`) resolve via
    // `getUnderlyingType()`.
    u.(TypedefType).getBaseType().stripType() instanceof StdBasicRegex
  )
}

/**
 * Gets the parameter of `f` whose type is a reference (or plain) to
 * `std::basic_regex`, i.e. the parameter that receives the regex object.
 */
private Parameter getRegexObjectParameter(Function f) {
  result = f.getAParameter() and
  isBasicRegexType(result.getType())
}

/**
 * Gets a parameter of `f` whose type is a string-like: `const char*`,
 * `const wchar_t*`, `std::basic_string`, or a `char`/`wchar_t` iterator
 * pair. Used to identify the subject string of match/search/replace calls.
 */
private Parameter getStringLikeParameter(Function f) {
  result = f.getAParameter() and
  exists(Type u | u = result.getUnspecifiedType().stripType() |
    // basic_string (by value or reference)
    u.(Class).hasQualifiedName("std", "basic_string")
    or
    u.(ClassTemplateInstantiation).getTemplate().hasQualifiedName("std", "basic_string")
    or
    // C strings: const char* / const wchar_t*
    exists(PointerType p |
      p = u
      or
      p = u.(ReferenceType).getBaseType().stripType()
    |
      p.getBaseType().stripType() instanceof CharType
      or
      p.getBaseType().stripType() instanceof Wchar_t
    )
  )
}

// ---------------------------------------------------------------------------
// Match / search / replace / iterator calls
// ---------------------------------------------------------------------------

/**
 * A free function in namespace `std` that matches a subject against a regex:
 * one of `regex_match`, `regex_search`, or `regex_replace`.
 */
private class StdRegexMatchFunction extends Function {
  StdRegexMatchFunction() {
    this.getNamespace().getName() = "std" and
    this.getName() = ["regex_match", "regex_search", "regex_replace"]
  }
}

/**
 * A class template instantiation of `std::regex_iterator` or
 * `std::regex_token_iterator`. Their constructors take a range and a regex.
 */
private class StdRegexIterator extends Class {
  StdRegexIterator() {
    this.(ClassTemplateInstantiation)
        .getTemplate()
        .hasQualifiedName("std", ["regex_iterator", "regex_token_iterator"])
    or
    this.hasQualifiedName("std", ["regex_iterator", "regex_token_iterator"])
  }
}

/**
 * Holds if `call` is a call site that matches a subject against a regex,
 * where `regexArg` is the argument holding the regex object and `subjectArg`
 * (if it exists) is the argument holding the subject string.
 */
predicate regexMatchCall(Call call, Expr regexArg, Expr subjectArg) {
  exists(Function f, Parameter rp |
    f = call.getTarget() and
    (
      f instanceof StdRegexMatchFunction
      or
      // Iterator constructors.
      f.(Constructor).getDeclaringType() instanceof StdRegexIterator
    ) and
    rp = getRegexObjectParameter(f) and
    regexArg = call.getArgument(rp.getIndex())
  |
    // First string-like parameter, if any, is the subject.
    exists(Parameter sp |
      sp = getStringLikeParameter(f) and
      subjectArg = call.getArgument(sp.getIndex()) and
      // Prefer the earliest such parameter (matches the standard argument
      // order for these overloads).
      not exists(Parameter sp2 |
        sp2 = getStringLikeParameter(f) and sp2.getIndex() < sp.getIndex()
      )
    )
  )
}

// ---------------------------------------------------------------------------
// Regex-flow sinks: places where a pattern (a StringLiteral) is used as a regex
// ---------------------------------------------------------------------------

/**
 * A regex-flow sink: an expression at which a value is used as the pattern
 * for a `std::basic_regex` (construction, `.assign(...)`), or as the pattern
 * argument of a free match/search/replace call that takes a raw pattern.
 */
class RegexPatternSink extends DataFlow::Node {
  RegexPatternSink() {
    // 1. Constructor argument 0 of std::basic_regex.
    exists(ConstructorCall cc, Constructor c |
      c = cc.getTarget() and
      c.getDeclaringType() instanceof StdBasicRegex and
      this.asExpr() = cc.getArgument(0)
    )
    or
    // 2. Argument 0 of a `basic_regex::assign(...)` call.
    exists(FunctionCall fc, MemberFunction m |
      m = fc.getTarget() and
      m.getDeclaringType() instanceof StdBasicRegex and
      m.hasName("assign") and
      this.asExpr() = fc.getArgument(0)
    )
  }
}

// ---------------------------------------------------------------------------
// Fast-path: only track literals that look regex-y
// ---------------------------------------------------------------------------

/**
 * A string literal that is a plausible ReDoS candidate: it contains at least
 * one unbounded-repetition quantifier (`+`, `*`, or `{n,}`). Used as an
 * optimisation to keep the taint-tracking configuration small; other regexes
 * are not interesting for the polynomial-ReDoS analysis anyway.
 */
class ExploitableStringLiteral extends StringLiteral {
  ExploitableStringLiteral() {
    exists(string s | s = this.getValue() |
      s.regexpMatch(".*[+*].*") or
      s.regexpMatch(".*\\{[0-9]+,[0-9]*\\}.*")
    )
  }
}

/**
 * A dataflow configuration tracking string literals that reach a regex
 * pattern construction/assignment site.
 */
private module RegexPatternFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node.asExpr() instanceof ExploitableStringLiteral }

  predicate isSink(DataFlow::Node node) { node instanceof RegexPatternSink }
}

private module RegexPatternFlow = TaintTracking::Global<RegexPatternFlowConfig>;

// ---------------------------------------------------------------------------
// Public predicates
// ---------------------------------------------------------------------------

/**
 * Holds if the `StringLiteral` `regex` flows to a modeled `std::regex`
 * construction or usage site.
 *
 * As an optimisation, only regexes containing an unbounded-repetition
 * quantifier (`+`, `*`, or `{n,}`) are considered.
 */
predicate usedAsRegex(StringLiteral regex) {
  regex instanceof ExploitableStringLiteral and
  RegexPatternFlow::flowFromExpr(regex)
}

/**
 * Holds if `regex` is a string literal used as a regular expression that is
 * matched against the expression `str`.
 *
 * As an optimisation, only regexes containing an unbounded-repetition
 * quantifier (`+`, `*`, or `{n,}`) are considered.
 */
predicate regexMatchedAgainst(StringLiteral regex, Expr str) {
  exists(RegexPatternSink patternSink, Variable v |
    RegexPatternFlow::flow(DataFlow::exprNode(regex), patternSink) and
    // Recover the variable that is being constructed / assigned to.
    (
      exists(ConstructorCall cc |
        patternSink.asExpr() = cc.getArgument(0) and
        cc.getEnclosingElement() = v.getInitializer()
      )
      or
      exists(FunctionCall fc |
        patternSink.asExpr() = fc.getArgument(0) and
        fc.getQualifier() = v.getAnAccess()
      )
    ) and
    // The regex variable is used as the regex argument to a match call.
    exists(Call matchCall, Expr regexArg |
      regexMatchCall(matchCall, regexArg, str) and
      regexArg = v.getAnAccess()
    )
  )
  or
  // Also handle the pattern being passed inline to a match call (no named
  // variable): rare in practice for std::regex, but supported for
  // completeness.
  exists(Call matchCall, Expr regexArg |
    regexMatchCall(matchCall, regexArg, str) and
    // The regex argument is a temporary `basic_regex(pattern)`.
    exists(ConstructorCall cc |
      cc.getTarget().getDeclaringType() instanceof StdBasicRegex and
      cc.getParent*() = regexArg and
      cc.getArgument(0) = regex.getFullyConverted()
      or
      cc.getTarget().getDeclaringType() instanceof StdBasicRegex and
      cc.getParent*() = regexArg and
      cc.getArgument(0) = regex
    )
  )
}

// ---------------------------------------------------------------------------
// Construction-site flags
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
  exists(EnumConstantAccess eca |
    eca = access.getAChild*() or eca = access
  |
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
 * Gets a flag argument (`syntax_option_type` / `match_flag_type`) for the
 * `basic_regex` construction (or `assign(...)`) whose pattern is `regex`.
 * Returns nothing if no explicit flag argument is supplied.
 */
private Expr getConstructionFlagArg(StringLiteral regex) {
  // basic_regex(pattern, flags) at variable construction.
  exists(ConstructorCall cc, Variable v |
    cc.getTarget().getDeclaringType() instanceof StdBasicRegex and
    cc.getEnclosingElement() = v.getInitializer() and
    RegexPatternFlow::flow(DataFlow::exprNode(regex), DataFlow::exprNode(cc.getArgument(0))) and
    result = cc.getArgument(1)
  )
  or
  // Temporary basic_regex(pattern, flags).
  exists(ConstructorCall cc |
    cc.getTarget().getDeclaringType() instanceof StdBasicRegex and
    RegexPatternFlow::flow(DataFlow::exprNode(regex), DataFlow::exprNode(cc.getArgument(0))) and
    result = cc.getArgument(1)
  )
  or
  // basic_regex::assign(pattern, flags).
  exists(FunctionCall fc |
    fc.getTarget().(MemberFunction).getDeclaringType() instanceof StdBasicRegex and
    fc.getTarget().hasName("assign") and
    RegexPatternFlow::flow(DataFlow::exprNode(regex), DataFlow::exprNode(fc.getArgument(0))) and
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
 * flag (`basic`, `extended`, `awk`, `grep`, or `egrep`). The Phase 1 parser
 * only models ECMAScript, so such regexes should be excluded from analysis.
 */
predicate hasNonEcmaScriptGrammarFlag(StringLiteral regex) {
  exists(string g | g = ["basic", "extended", "awk", "grep", "egrep"] |
    containsRegexFlag(getConstructionFlagArg(regex), g)
  )
}

/**
 * Holds if `regex` is constructed with an explicit ECMAScript grammar flag.
 * This is the default, and also the case that the Phase 1 parser handles.
 */
predicate hasEcmaScriptGrammarFlag(StringLiteral regex) {
  containsRegexFlag(getConstructionFlagArg(regex), "ECMAScript")
}
