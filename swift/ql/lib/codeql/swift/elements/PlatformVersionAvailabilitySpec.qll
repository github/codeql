private import codeql.swift.generated.PlatformVersionAvailabilitySpec

class PlatformVersionAvailabilitySpec extends Generated::PlatformVersionAvailabilitySpec {
  override string toString() { result = this.getPlatform() + " " + this.getVersion() }
}
