import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import utils.test.InlineFlowTest
import semmle.go.security.LogInjection
import TaintFlowTest<LogInjection::Config>
