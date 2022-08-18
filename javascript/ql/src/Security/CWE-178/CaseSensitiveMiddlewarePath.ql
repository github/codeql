/**
 * @name Case-sensitive middleware path
 * @description Middleware with case-sensitive paths do not protect endpoints with case-insensitive paths.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.3
 * @precision high
 * @id js/case-sensitive-middleware-path
 * @tags security
 *       external/cwe/cwe-178
 */

import javascript

/**
 * Converts `s` to upper case, or to lower-case if it was already upper case.
 */
bindingset[s]
string toOtherCase(string s) {
  if s.regexpMatch(".*[a-z].*") then result = s.toUpperCase() else result = s.toLowerCase()
}

RegExpCharacterClass getEnclosingClass(RegExpTerm term) {
  term = result.getAChild()
  or
  term = result.getAChild().(RegExpRange).getAChild()
}

/**
 * Holds if `term` seems to distinguish between upper and lower case letters, assuming the `i` flag is not present.
 */
pragma[inline]
predicate isLikelyCaseSensitiveRegExp(RegExpTerm term) {
  exists(RegExpConstant const |
    const = term.getAChild*() and
    const.getValue().regexpMatch(".*[a-zA-Z].*") and
    not getEnclosingClass(const).getAChild().(RegExpConstant).getValue() =
      toOtherCase(const.getValue()) and
    not const.getParent*() instanceof RegExpNegativeLookahead and
    not const.getParent*() instanceof RegExpNegativeLookbehind
  )
}

import semmle.javascript.security.regexp.NfaUtils as NfaUtils

/** Holds if `s` is a relevant regexp term were we want to compute a string that matches the term (for `getCaseSensitiveBypassExample`). */
predicate isCand(NfaUtils::State s) {
  s.getRepr().isRootTerm() and
  exists(DataFlow::RegExpCreationNode creation |
    isCaseSensitiveMiddleware(_, creation, _) and
    s.getRepr().getRootTerm() = creation.getRoot()
  )
}

import NfaUtils::PrefixConstruction<isCand/1> as Prefix

/** Gets a string matched by `term`. */
string getExampleString(RegExpTerm term) {
  result = Prefix::prefix(any(NfaUtils::State s | s.getRepr() = term))
}

string getCaseSensitiveBypassExample(RegExpTerm term) {
  exists(string byPassExample |
    byPassExample = getExampleString(term) and
    result = toOtherCase(byPassExample) and
    result != byPassExample // getting an byPassExample string is approximate; ensure we got a proper case-change byPassExample
  )
}

/**
 * Holds if `setup` has a path-argument `arg` referring to the given case-sensitive `regexp`.
 */
predicate isCaseSensitiveMiddleware(
  Routing::RouteSetup setup, DataFlow::RegExpCreationNode regexp, DataFlow::Node arg
) {
  exists(DataFlow::MethodCallNode call |
    setup = Routing::getRouteSetupNode(call) and
    (
      setup.definitelyResumesDispatch()
      or
      // If applied to all HTTP methods, be a bit more lenient in detecting middleware
      setup.mayResumeDispatch() and
      not exists(setup.getOwnHttpMethod())
    ) and
    arg = call.getArgument(0) and
    regexp.getAReference().flowsTo(arg) and
    isLikelyCaseSensitiveRegExp(regexp.getRoot()) and
    exists(string flags |
      flags = regexp.getFlags() and
      not RegExp::isIgnoreCase(flags)
    )
  )
}

predicate isGuardedCaseInsensitiveEndpoint(
  Routing::RouteSetup endpoint, Routing::RouteSetup middleware
) {
  isCaseSensitiveMiddleware(middleware, _, _) and
  exists(DataFlow::MethodCallNode call |
    endpoint = Routing::getRouteSetupNode(call) and
    endpoint.isGuardedByNode(middleware) and
    call.getArgument(0).mayHaveStringValue(_)
  )
}

/**
 * Gets an example path that will hit `endpoint`.
 * Query parameters (e.g. the ":param" in "/foo/:param") have been replaced with example values.
 */
string getAnEndpointExample(Routing::RouteSetup endpoint) {
  exists(string raw |
    raw = endpoint.getRelativePath().toLowerCase() and
    result = raw.regexpReplaceAll(":\\w+\\b|\\*", ["a", "1"])
  )
}

import semmle.javascript.security.regexp.RegexpMatching as RegexpMatching

/**
 * Holds if the regexp matcher should test whether `root` matches `str`.
 * The result is used to test whether a case-sensitive bypass exists.
 */
predicate isMatchingCandidate(
  RegexpMatching::RootTerm root, string str, boolean ignorePrefix, boolean testWithGroups
) {
  exists(
    Routing::RouteSetup middleware, Routing::RouteSetup endPoint,
    DataFlow::RegExpCreationNode regexp
  |
    isCaseSensitiveMiddleware(middleware, regexp, _) and
    isGuardedCaseInsensitiveEndpoint(endPoint, middleware)
  |
    root = regexp.getRoot() and
    exists(getCaseSensitiveBypassExample(root)) and
    ignorePrefix = true and
    testWithGroups = false and
    str = [getCaseSensitiveBypassExample(root), getAnEndpointExample(endPoint)]
  )
}

import RegexpMatching::RegexpMatching<isMatchingCandidate/4> as Matcher

from
  DataFlow::RegExpCreationNode regexp, Routing::RouteSetup middleware, Routing::RouteSetup endpoint,
  DataFlow::Node arg, string byPassExample
where
  isCaseSensitiveMiddleware(middleware, regexp, arg) and
  byPassExample = getCaseSensitiveBypassExample(regexp.getRoot()) and
  isGuardedCaseInsensitiveEndpoint(endpoint, middleware) and
  exists(string endpointExample | endpointExample = getAnEndpointExample(endpoint) |
    Matcher::matches(regexp.getRoot(), endpointExample) and
    not Matcher::matches(regexp.getRoot(), byPassExample)
  )
select arg,
  "This route uses a case-sensitive path $@, but is guarding a case-insensitive path $@. A path such as '"
    + byPassExample + "' will bypass the middleware.", regexp, "pattern", endpoint, "here"
