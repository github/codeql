import go

query predicate serverRequests(DataFlow::ParameterNode node) { node instanceof GoMicro::Request }

query predicate clientRequests(DataFlow::Node node) {
  node instanceof GoMicro::ClientRequestUrlAsSink
}
