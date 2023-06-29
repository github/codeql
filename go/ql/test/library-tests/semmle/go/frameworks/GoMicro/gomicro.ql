import go
import semmle.go.frameworks.GoMicro

query predicate requests(DataFlow::ParameterNode node) { node instanceof GoMicro::Request }
