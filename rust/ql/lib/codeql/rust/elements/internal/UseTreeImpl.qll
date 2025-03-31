/**
 * This module provides a hand-modifiable wrapper around the generated class `UseTree`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.UseTree

/**
 * INTERNAL: This module contains the customizable definition of `UseTree` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A UseTree. For example:
   * ```rust
   * use std::collections::HashMap;
   * use std::collections::*;
   * use std::collections::HashMap as MyHashMap;
   * use std::collections::{self, HashMap, HashSet};
   * ```
   */
  class UseTree extends Generated::UseTree {
    override string toStringImpl() {
      result = strictconcat(int i | | this.toStringPart(i) order by i)
    }

    private string toStringPart(int index) {
      result = this.getPath().toStringImpl() and index = 0
      or
      result = "::{...}" and this.hasUseTreeList() and index = 1
      or
      result = "::*" and this.isGlob() and index = 2
      or
      result = " as " + this.getRename().getName().getText() and index = 3
    }
  }
}
