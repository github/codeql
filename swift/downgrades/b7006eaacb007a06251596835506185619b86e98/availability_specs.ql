class AvailabilitySpec extends @availability_spec {
  string toString() { none() }
}

query predicate new_other_availability_specs(AvailabilitySpec id) {
  availability_specs(id) and
  availability_spec_is_wildcard(id)
}

query predicate new_platform_version_availability_specs(
  AvailabilitySpec id, string platform, string version
) {
  availability_specs(id) and
  availability_spec_platforms(id, platform) and
  availability_spec_versions(id, version)
}
