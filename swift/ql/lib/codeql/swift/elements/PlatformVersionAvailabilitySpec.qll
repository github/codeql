private import codeql.swift.generated.PlatformVersionAvailabilitySpec

class PlatformVersionAvailabilitySpec extends Generated::PlatformVersionAvailabilitySpec {
  override string toString() { result = getPlatform() + " " + getVersion() }
}
