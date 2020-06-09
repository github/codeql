/**
 * Provides classes modeling security-relevant aspects of the third-part libraries.
 */

import go

module ThirdPartEncodingJson {
    /** Provides models of some functions in the `github.com/json-iterator/go` package. */
    class JsoniterUnmarshalingFunction extends TaintTracking::FunctionModel, UnmarshalingFunction::Range {

        JsoniterUnmarshalingFunction() {
            this.hasQualifiedName("github.com/json-iterator/go", "Unmarshal")
        }

        override DataFlow::FunctionInput getAnInput() { result.isParameter(0) }
        override DataFlow::FunctionOutput getOutput() { result.isParameter(1) }

        override string getFormat() { result = "JSON" }

        override predicate hasTaintFlow(DataFlow::FunctionInput inp, DataFlow::FunctionOutput outp) {
            inp = getAnInput() and outp = getOutput()
        }
    }
}

