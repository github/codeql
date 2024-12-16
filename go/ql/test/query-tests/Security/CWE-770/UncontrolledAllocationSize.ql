import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import semmle.go.security.UncontrolledAllocationSize
import utils.test.InlineFlowTest
import FlowTest<UncontrolledAllocationSize::Config, UncontrolledAllocationSize::Config>
