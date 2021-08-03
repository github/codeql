import javascript

import semmle.javascript.security.dataflow.RequestForgeryCustomizations
import semmle.javascript.security.dataflow.UrlConcatenation

class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "SSRF" }

    override predicate isSource(DataFlow::Node source) { source instanceof RequestForgery::Source }

    override predicate isSink(DataFlow::Node sink) { sink instanceof RequestForgery::Sink }

    override predicate isSanitizer(DataFlow::Node node) {
        super.isSanitizer(node) or
        node instanceof RequestForgery::Sanitizer
    }

    override predicate isSanitizerEdge(DataFlow::Node source, DataFlow::Node sink) {
        sanitizingPrefixEdge(source, sink)
    }
    override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode nd) {
        nd instanceof IntegerCheck or
        nd instanceof ValidatorCheck
    }
}

/**
 * Number.isInteger is a sanitizer guard because a number can't be used to exploit a SSRF.
 */
class IntegerCheck extends TaintTracking::SanitizerGuardNode, DataFlow::CallNode{
    IntegerCheck() {
      this = DataFlow::globalVarRef("Number").getAMemberCall("isInteger")
    }

    override predicate sanitizes(boolean outcome, Expr e){
      outcome = true and 
      e = getArgument(0).asExpr()
    }
}

/**
 * ValidatorCheck identifies if exists a call to validator's library methods.
 * validator is a library which has a variety of input-validation functions. We are interesed in
 * checking that source is a number (any type of number) or an alphanumeric value.
 */
class ValidatorCheck extends TaintTracking::SanitizerGuardNode, DataFlow::CallNode {
    ValidatorCheck() {
        exists(
            DataFlow::SourceNode mod, string method |
            mod = DataFlow::moduleImport("validator") and 
            this = mod.getAChainedMethodCall(method)
            and method in ["isAlphanumeric", "isAlpha", "isDecimal", "isFloat", 
                "isHexadecimal", "isHexColor", "isInt", "isNumeric", "isOctal", "isUUID"]
        )
    }
    override predicate sanitizes(boolean outcome, Expr e){
        outcome = true and 
        e = getArgument(0).asExpr()
    }
}
