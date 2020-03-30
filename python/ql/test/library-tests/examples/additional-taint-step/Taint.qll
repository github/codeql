import python
import semmle.python.security.TaintTracking
import semmle.python.security.strings.Untrusted

class SimpleSource extends TaintSource {
    SimpleSource() { this.(NameNode).getId() = "TAINTED_STRING" }

    override predicate isSourceOf(TaintKind kind) { kind instanceof ExternalStringKind }

    override string toString() { result = "taint source" }
}

class MyTestTaintKind extends TaintKind {
    MyTestTaintKind() { this = "MyTestTaintKind" }
}

class TestConfig extends TaintTracking::Configuration {
    TestConfig() { this = "TestConfig" }

    override predicate isSource(TaintTracking::Source source) { source instanceof SimpleSource }

    override predicate isAdditionalFlowStep(
            DataFlow::Node src, DataFlow::Node dest, TaintKind srckind, TaintKind destkind
        ) {
        // Handling `mylib_some_func`.
        (
            exists(FunctionValue fv, CallNode call |
                fv = Value::named("test.mylib_some_func") and
                call = fv.getACall() and
                dest.asCfgNode() = call and
                fv.getArgumentForCall(call, 0) = src.asCfgNode()
            ) and
            srckind instanceof ExternalStringKind and
            destkind instanceof MyTestTaintKind
        )
        or
        // Handling `mylib_call_indirectly`.
        //
        // This could have been added with isAdditionalFlowStep/2, to avoid the
        // `srckind = destkind` part
        (
            exists(FunctionValue fv, CallNode call, PythonFunctionValue called_function |
                fv = Value::named("test.mylib_call_indirectly") and
                call = fv.getACall() and
                called_function = get_real_function_value(fv.getArgumentForCall(call, 0).pointsTo()) and
                (
                    // positional arguments
                    exists(int i, int offset | i >= 0 |
                        call.getArg(i+1) = src.asCfgNode() and
                        (if called_function.isNormalMethod() then offset = 1 else offset = 0) and
                        called_function.getParameter(i+offset) = dest.asCfgNode()
                    )
                    or
                    // keyword arguments
                    exists(string name |
                        call.getArgByName(name) = src.asCfgNode() and
                        called_function.getParameterByName(name) = dest.asCfgNode() and
                        // argument 0 to `mylib_call_indirectly` is not passed to called_function
                        not call.getArgByName(name) = fv.getArgumentForCall(call, 0)
                    )
                ) and
                srckind = destkind
            )
        )
    }

    override predicate isSink(TaintTracking::Sink sink) { none() }
}

// TODO: Hack since this doesn't hold
// `forall(PythonFunctionValue fv | fv = fv.getACall().(CallNode).getFunction().pointsTo())`
// and there is no good way to get the value right now

import semmle.python.objects.Callables

private PythonFunctionValue get_real_function_value(CallableValue v)
{
    v instanceof PythonFunctionValue and
    result = v
    or
    result = v.(BoundMethodObjectInternal).getFunction()
}
