private import codeql.swift.generated.AvailabilityInfo

class AvailabilityInfo extends Generated::AvailabilityInfo {
  override string toString() {
    result = "#available" and not isUnavailable()
    or
    result = "#unavailable" and isUnavailable()
  }
}
