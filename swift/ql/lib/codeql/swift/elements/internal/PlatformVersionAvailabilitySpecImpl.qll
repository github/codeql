private import codeql.swift.generated.PlatformVersionAvailabilitySpec

module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * An availability spec based on platform and version, for example `macOS 12` or `watchOS 14`
   */
  class PlatformVersionAvailabilitySpec extends Generated::PlatformVersionAvailabilitySpec {
    override string toString() { result = this.getPlatform() + " " + this.getVersion() }
  }
}
