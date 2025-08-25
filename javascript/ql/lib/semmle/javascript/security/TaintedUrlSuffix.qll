/**
 * Provides a flow label for reasoning about URLs with a tainted query and fragment part,
 * which we collectively refer to as the "suffix" of the URL.
 */

import javascript

/**
 * Provides a flow label for reasoning about URLs with a tainted query and fragment part,
 * which we collectively refer to as the "suffix" of the URL.
 */
module TaintedUrlSuffix {
  import TaintedUrlSuffixCustomizations::TaintedUrlSuffix

  deprecated private class ConcreteTaintedUrlSuffixLabel extends TaintedUrlSuffixLabel {
    ConcreteTaintedUrlSuffixLabel() { this = this }
  }
}
