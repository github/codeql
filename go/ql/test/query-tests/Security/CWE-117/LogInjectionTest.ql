import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import TestUtilities.InlineFlowTest
import semmle.go.security.LogInjection
import TaintFlowTest<LogInjection::Config>
