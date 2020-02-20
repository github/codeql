import python
import semmle.python.security.TaintTracking
import semmle.python.security.strings.Untrusted

class SimpleSource extends TaintSource {
    SimpleSource() { this.(NameNode).getId() = "TAINTED_STRING" }

    override predicate isSourceOf(TaintKind kind) { kind instanceof ExternalStringKind }

    override string toString() { result = "taint source" }
}

class MySimpleSanitizer extends Sanitizer {
    MySimpleSanitizer() { this = "MySimpleSanitizer" }

    /**
     * The test `if is_safe(arg):` sanitizes `arg` on its `true` edge.
     *
     * Can't handle `if not is_safe(arg):` :\ that's why it's called MySimpleSanitizer
     *
     */
    override predicate sanitizingEdge(TaintKind taint, PyEdgeRefinement test) {
        taint instanceof ExternalStringKind and
        exists(CallNode call |
            test.getTest() = call and test.getSense() = true
        |
            call = Value::named("test.is_safe").getACall() and
            test.getInput().getAUse() = call.getAnArg()
        )
    }
}

class MySanitizerHandlingNot extends Sanitizer {
    MySanitizerHandlingNot() { this = "MySanitizerHandlingNot" }

    /** The test `if is_safe(arg):` sanitizes `arg` on its `true` edge. */
    override predicate sanitizingEdge(TaintKind taint, PyEdgeRefinement test) {
        taint instanceof ExternalStringKind and
        exists(CallNode call |
            clears_taint_on_true(call, test.getTest(), test.getSense())
        |
            call = Value::named("test.is_safe").getACall() and
            test.getInput().getAUse() = call.getAnArg()
        )
    }

    private predicate clears_taint_on_true(ControlFlowNode final_test, ControlFlowNode test, boolean sense) {
        final_test = test and
        sense = true
        or
        test.(UnaryExprNode).getNode().getOp() instanceof Not and
        exists(ControlFlowNode nested_test |
            nested_test = test.(UnaryExprNode).getOperand() and
            clears_taint_on_true(final_test, nested_test, sense.booleanNot())
        )
    }
}

class TestConfig extends TaintTracking::Configuration {
    TestConfig() { this = "TestConfig" }

    override predicate isSanitizer(Sanitizer sanitizer) {
        sanitizer instanceof MySanitizerHandlingNot
    }

    override predicate isSource(TaintTracking::Source source) {
        source instanceof SimpleSource
    }

    override predicate isSink(TaintTracking::Sink sink) {
        none()
    }
}
