/**
 * Provides classes and predicates for reasoning about C++ standard-library
 * regular-expression **usage** (dataflow layer).
 *
 * This module identifies which `StringLiteral`s flow (via global taint
 * tracking) into a `std::basic_regex` construction or into one of the free
 * matching functions (`std::regex_match`, `std::regex_search`,
 * `std::regex_replace`) or iterators (`std::regex_iterator`,
 * `std::regex_token_iterator`).
 *
 * The grammar dialect and construction-site *flags* of a regex literal
 * (`icase`, `multiline`, `basic`, `extended`, etc.) are independent of the
 * dataflow analysis - they are properties of the parsed literal itself -
 * and live in the flow-free module
 * `semmle.code.cpp.regex.internal.RegexGrammar`. This module re-exports the
 * public predicates from there so existing consumers (`hasIgnoreCaseFlag`,
 * `hasMultilineFlag`, `regexGrammar`, ...) can continue to import them
 * from `RegexFlowConfigs`.
 *
 * The `regexMatchedAgainst` predicate mirrors the intent of the Java
 * `RegexFlowConfigs.qll` library.
 *
 * All standard `std::regex` grammars are now modeled: ECMAScript (default),
 * POSIX BRE (`basic`/`grep`), and POSIX ERE (`extended`/`egrep`/`awk`).
 * Grammar selection and ReDoS-eligibility are independent axes - see
 * `isBacktrackingEngine` for the latter.
 */

import cpp
private import semmle.code.cpp.dataflow.new.DataFlow
private import semmle.code.cpp.dataflow.new.TaintTracking
private import semmle.code.cpp.regex.internal.RegexGrammar as RG

// ---------------------------------------------------------------------------
// Re-exports from the flow-free grammar/flag module.
// These are kept in scope for backward compatibility so that consumers can
// continue to import them from `RegexFlowConfigs`.
// ---------------------------------------------------------------------------
/**
 * A `std::basic_regex` class type (or instantiation thereof, e.g. `std::regex`,
 * `std::wregex`). Defined in `RegexGrammar`; re-exported here.
 */
class StdBasicRegex = RG::StdBasicRegex;

/** See `RegexGrammar::TRegexGrammar`. */
class TRegexGrammar = RG::TRegexGrammar;

/** See `RegexGrammar::regexGrammar`. */
TRegexGrammar regexGrammar(StringLiteral regex) { result = RG::regexGrammar(regex) }

/** See `RegexGrammar::hasConcreteGrammar`. */
predicate hasConcreteGrammar(TRegexGrammar grammar) { RG::hasConcreteGrammar(grammar) }

/** See `RegexGrammar::hasIgnoreCaseFlag`. */
predicate hasIgnoreCaseFlag(StringLiteral regex) { RG::hasIgnoreCaseFlag(regex) }

/** See `RegexGrammar::hasMultilineFlag`. */
predicate hasMultilineFlag(StringLiteral regex) { RG::hasMultilineFlag(regex) }

/** See `RegexGrammar::hasNonEcmaScriptGrammarFlag`. */
predicate hasNonEcmaScriptGrammarFlag(StringLiteral regex) {
  RG::hasNonEcmaScriptGrammarFlag(regex)
}

/** See `RegexGrammar::hasEcmaScriptGrammarFlag`. */
predicate hasEcmaScriptGrammarFlag(StringLiteral regex) { RG::hasEcmaScriptGrammarFlag(regex) }

// ---------------------------------------------------------------------------
// std::basic_regex type helpers
// ---------------------------------------------------------------------------
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
      not exists(Parameter sp2 | sp2 = getStringLikeParameter(f) and sp2.getIndex() < sp.getIndex())
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
// Fast-path: only track literals that look regex-y.
// `ExploitableStringLiteral` is defined in the flow-free `RegexGrammar`
// module; re-exported here for backward compatibility.
// ---------------------------------------------------------------------------
class ExploitableStringLiteral = RG::ExploitableStringLiteral;

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
    exists(Expr regexArg |
      regexMatchCall(_, regexArg, str) and
      regexArg = v.getAnAccess()
    )
  )
  or
  // Also handle the pattern being passed inline to a match call (no named
  // variable): rare in practice for std::regex, but supported for
  // completeness.
  exists(Expr regexArg |
    regexMatchCall(_, regexArg, str) and
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
// ReDoS engine gating
// ---------------------------------------------------------------------------
/**
 * Holds if `regex` is used with a `std::regex` matching engine that performs
 * backtracking, so that super-linear-backtracking ReDoS is possible.
 *
 * `std::regex` backtracks for the ECMAScript, `basic` (BRE), and `extended`
 * (ERE) grammars. The POSIX tool-style grammars `awk`, `grep`, and `egrep`
 * are treated as linear-time (non-backtracking) matching semantics for the
 * purposes of the ReDoS queries and are excluded here.
 *
 * Grammar selection and ReDoS-eligibility are independent axes: two flags
 * can select the same grammar yet differ in ReDoS-eligibility (for example
 * `extended` and `egrep` both parse as ERE, but only `extended` is
 * backtracking-eligible).
 */
predicate isBacktrackingEngine(StringLiteral regex) {
  usedAsRegex(regex) and
  not RG::hasNonBacktrackingGrammarFlag(regex)
}
