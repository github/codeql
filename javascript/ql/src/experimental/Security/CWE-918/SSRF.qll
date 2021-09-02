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
        nd instanceof ValidatorCheck or
        nd instanceof TernaryOperatorSanitizerGuard
    }
}

/** TODO add comment */
class TernaryOperatorSanitizerGuard extends TaintTracking::SanitizerGuardNode {
    TaintTracking::SanitizerGuardNode originalGuard;

    TernaryOperatorSanitizerGuard() {
    exists(DataFlow::Node falseNode |
        this.getAPredecessor+() = falseNode and 
        falseNode.asExpr().(BooleanLiteral).mayHaveBooleanValue(false)
    ) and
    this.getAPredecessor+() = originalGuard and 
    not this.asExpr() instanceof LogicalBinaryExpr
    }

    override predicate sanitizes(boolean outcome, Expr e) {
    not this.asExpr() instanceof LogNotExpr and 
    originalGuard.sanitizes(outcome, e) 
    or
    exists(boolean originalOutcome |
        this.asExpr() instanceof LogNotExpr and
        originalGuard.sanitizes(originalOutcome, e) and
        (
        originalOutcome = true and outcome = false 
        or
        originalOutcome = false and outcome = true
        )
    )
    }
}

/** TODO add comment */
class TernaryOperatorSanitizer extends RequestForgery::Sanitizer {
    TernaryOperatorSanitizer() {
    exists(
        TaintTracking::SanitizerGuardNode guard, IfStmt ifStmt, DataFlow::Node taintedInput, boolean outcome,
        Stmt r, DataFlow::Node falseNode
    |
        ifStmt.getCondition().flow().getAPredecessor+() = guard and 
        ifStmt.getCondition().flow().getAPredecessor+() = falseNode and 
        falseNode.asExpr().(BooleanLiteral).mayHaveBooleanValue(false) and 
        not ifStmt.getCondition() instanceof LogicalBinaryExpr and 
        guard.sanitizes(outcome, taintedInput.asExpr()) and 
        (
        outcome = true and r = ifStmt.getThen() and not ifStmt.getCondition() instanceof LogNotExpr
        or
        outcome = false and r = ifStmt.getElse() and not ifStmt.getCondition() instanceof LogNotExpr
        or
        outcome = false and r = ifStmt.getThen() and ifStmt.getCondition() instanceof LogNotExpr
        or
        outcome = true and r = ifStmt.getElse() and ifStmt.getCondition() instanceof LogNotExpr
        ) and
        r.getFirstControlFlowNode()
            .getBasicBlock()
            .(ReachableBasicBlock)
            .dominates(this.getBasicBlock())
    )
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
