/**
 * @name Server-side request forgery
 * @description Sending network requests with user-controlled data allows for request forgery attacks.
 * @kind path-problem
 * @problem.severity error
 * @sub-severity TODO
 * @precision TODO
 * @id py/ssrf
 * @tags security
 *       external/cwe/cwe-918
 */

import python
import semmle.python.security.Paths
import semmle.python.web.HttpRequest // incoming server request
import semmle.python.web.ClientHttpRequest // outgoing client request
import semmle.python.security.strings.Untrusted
import semmle.python.regex

// hmm, for a whole URL this is *not* a good sanitizer
// for `split_res = urlsplit(url)`, it's a good sanitizer for `split_res.path`,
// but *not* for `split_res.netloc` or `split_res.hostname`
private class StringStartswithConstSanitizer extends Sanitizer {
    StringStartswithConstSanitizer() { this = "StringStartswithConstSanitizer" }

    /** The test `if untrusted.startswith("KNOWN_VALUE"):` sanitizes `untrusted` on its `true` edge. */
    override predicate sanitizingEdge(TaintKind taint, PyEdgeRefinement test) {
        taint instanceof StringKind and
        exists(CallNode call |
            call = test.getTest() and test.getSense() = true
            or
            test.getTest().(UnaryExprNode).getNode().getOp() instanceof Not and
            call = test.getTest().(UnaryExprNode).getOperand() and
            test.getSense() = false
        |
            call.getFunction().(AttrNode).getName() = "startswith" and
            count(call.getAnArg()) = 1 and
            call.getAnArg().getNode() instanceof StrConst
        )
    }
}

private class UrlReMatchSanitizer extends Sanitizer {
    UrlReMatchSanitizer() { this = "UrlReMatchSanitizer" }

    /** The test `if re.match(regexp, untrusted)` (and friends) sanitizes `untrusted` on its `true` edge. */
    override predicate sanitizingEdge(TaintKind taint, PyEdgeRefinement test) {
        taint instanceof StringKind and
        clears_taint(_, test.getInput().getAUse(), test.getTest(), test.getSense())
    }

    private predicate clears_taint(ControlFlowNode final_test, ControlFlowNode tainted, ControlFlowNode test, boolean sense) {
        tests_regex(final_test, tainted, sense)
        or
        test.(UnaryExprNode).getNode().getOp() instanceof Not and
        exists(ControlFlowNode nested_test |
            nested_test = test.(UnaryExprNode).getOperand() and
            clears_taint(final_test, tainted, nested_test, sense.booleanNot())
        )
    }

    /** holds for `re.match()` (and friends) on `true` edge */
    private predicate tests_regex(CallNode regexTest, ControlFlowNode tainted, boolean sense) {
        sense = true and
        exists(ModuleValue re_module | re_module = Module::named("re") |
            regexTest.getFunction().pointsTo(re_module.attr(_)) and
            // the tainted string should not be used as the regex (which is always arg 0)
            exists(int i | not i = 0 | regexTest.getArg(i) = tainted)
        )
    }
}

class SSRFConfiguration extends TaintTracking::Configuration {
    SSRFConfiguration() { this = "SSRFConfiguration" }

    override predicate isSanitizer(Sanitizer sanitizer) {
        sanitizer instanceof UrlReMatchSanitizer
        or
        sanitizer instanceof StringStartswithConstSanitizer
    }

    override predicate isSource(TaintTracking::Source source) {
        source instanceof HttpRequestTaintSource
    }

    override predicate isSink(TaintTracking::Sink sink) {
        sink instanceof Client::HttpRequestUrlTaintSink
    }
}

from SSRFConfiguration config, TaintedPathSource src, TaintedPathSink sink
where config.hasFlowPath(src, sink)
select sink.getSink(), src, sink, "Server-side request forgery vulnerability due to $@.",
    src.getSource(), "a user-provided value"
