import experimental.adaptivethreatmodeling.StandardEndpointLabels as StandardEndpointLabels

query predicate endpointLabelsAreInRangeConsistency(string range, string label) {
  exists(StandardEndpointLabels::Labels::EndpointLabeller labeller |
    range = labeller.toString().replaceAll("/**", "") and
    label = labeller.getLabel(_)
  |
    not (label.matches(range + "/%") or label = range)
  )
}
