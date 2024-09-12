cached
private module Cached {
  // Not using CFG splitting, so the following are just placeholder types.
  cached
  newtype TSplitKind = TSplitKindUnit()

  cached
  newtype TSplit = TSplitUnit()
}

import Cached

/** A split for a control flow node. */
class Split extends TSplit {
  /** Gets a textual representation of this split. */
  string toString() { none() }
}
