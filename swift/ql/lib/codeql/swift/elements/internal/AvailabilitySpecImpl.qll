private import codeql.swift.generated.AvailabilitySpec

/**
 * INTERNAL: This module contains the customizable definition of `AvailabilitySpec` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * An availability spec, that is, part of an `AvailabilityInfo` condition. For example `iOS 12` and `*` in:
   * ```
   * if #available(iOS 12, *)
   * ```
   */
  class AvailabilitySpec extends Generated::AvailabilitySpec {
    override string toStringImpl() {
      if this.isWildcard()
      then result = "*"
      else result = this.getPlatform() + " " + this.getVersion()
    }
  }
}
