import go
import semmle.go.security.UncontrolledAllocationSize
import TestUtilities.InlineFlowTest
import FlowTest<UncontrolledAllocationSize::Config, UncontrolledAllocationSize::Config>
