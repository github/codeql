import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import semmle.go.security.UncontrolledAllocationSize
import TestUtilities.InlineFlowTest
import FlowTest<UncontrolledAllocationSize::Config, UncontrolledAllocationSize::Config>
