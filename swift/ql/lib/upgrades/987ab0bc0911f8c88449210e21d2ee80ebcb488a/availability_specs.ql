class AvailabilitySpec extends @availability_spec {
  string toString() { none() }
}

query predicate new_availability_specs(AvailabilitySpec id) {
  platform_version_availability_specs(id, _, _)
  or
  other_availability_specs(id)
}

query predicate new_availability_spec_platforms(AvailabilitySpec id, string platform) {
  platform_version_availability_specs(id, platform, _)
}

query predicate new_availability_spec_versions(AvailabilitySpec id, string version) {
  platform_version_availability_specs(id, _, version)
}

query predicate new_availability_spec_is_wildcard(AvailabilitySpec id) {
  other_availability_specs(id)
}
