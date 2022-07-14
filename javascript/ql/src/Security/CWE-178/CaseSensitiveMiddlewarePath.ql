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

/**
 * Gets a string matched by `term`, or part of such a string.
 */
string getExampleString(RegExpTerm term) {
  result = term.getAMatchedString()
  or
  // getAMatchedString does not recurse into sequences. Perform one step manually.
  exists(RegExpSequence seq | seq = term |
    result =
      strictconcat(RegExpTerm child, int i, string text |
        child = seq.getChild(i) and
        (
          text = child.getAMatchedString()
          or
          not exists(child.getAMatchedString()) and
          text = ""
        )
      |
        text order by i
      )
  )
}

string getCaseSensitiveBypassExample(RegExpTerm term) {
  exists(string example |
    example = getExampleString(term) and
    result = toOtherCase(example) and
    result != example // getting an example string is approximate; ensure we got a proper case-change example
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

from
  DataFlow::RegExpCreationNode regexp, Routing::RouteSetup middleware, Routing::RouteSetup endpoint,
  DataFlow::Node arg, string example
where
  isCaseSensitiveMiddleware(middleware, regexp, arg) and
  example = getCaseSensitiveBypassExample(regexp.getRoot()) and
  isGuardedCaseInsensitiveEndpoint(endpoint, middleware) and
  exists(endpoint.getRelativePath().toLowerCase().indexOf(example.toLowerCase()))
select arg,
  "This route uses a case-sensitive path $@, but is guarding a case-insensitive path $@. A path such as '"
    + example + "' will bypass the middleware.", regexp, "pattern", endpoint, "here"
