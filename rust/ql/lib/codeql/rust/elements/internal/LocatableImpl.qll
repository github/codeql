/**
 * This module provides a hand-modifiable wrapper around the generated class `Locatable`.
 *
 * INTERNAL: Do not use.
 */

import codeql.Locations
private import codeql.rust.elements.internal.LocationImpl
private import codeql.rust.elements.internal.generated.Locatable
private import codeql.rust.elements.internal.generated.Synth
private import codeql.rust.elements.internal.generated.Raw
private import codeql.rust.internal.CachedStages

/**
 * INTERNAL: This module contains the customizable definition of `Locatable` and should not
 * be referenced directly.
 */
module Impl {
  abstract class SynthLocatable extends Locatable {
    pragma[nomagic]
    abstract predicate hasSynthLocationInfo(
      File file, int startline, int startcolumn, int endline, int endcolumn
    );

    final override Location getLocation() {
      exists(File file, int startline, int startcolumn, int endline, int endcolumn |
        this.hasSynthLocationInfo(file, startline, startcolumn, endline, endcolumn) and
        result.hasLocationFileInfo(file, startline, startcolumn, endline, endcolumn)
      )
    }
  }

  class Locatable extends Generated::Locatable {
    cached
    Location getLocation() {
      Stages::AstStage::ref() and
      result = getLocationDefault(this)
    }

    /**
     * Gets the primary file where this element occurs.
     */
    File getFile() { result = this.getLocation().getFile() }

    /** Holds if this element is from source code. */
    predicate fromSource() { this.getFile().fromSource() }
  }

  private @location_default getDbLocation(Locatable l) {
    locatable_locations(Synth::convertLocatableToRaw(l), result)
  }

  private MacroCall getImmediatelyEnclosingMacroCall(AstNode n) {
    result = n.getParentNode()
    or
    exists(AstNode mid |
      result = getImmediatelyEnclosingMacroCall(mid) and
      n.getParentNode() = mid and
      not mid instanceof MacroCall
    )
  }

  /** Gets the non-synthesized location of `l`, if any. */
  LocationImpl::LocationDefault getLocationDefault(Locatable l) {
    result = LocationImpl::TLocationDefault(getDbLocation(l))
    or
    not exists(getDbLocation(l)) and
    result = getLocationDefault(getImmediatelyEnclosingMacroCall(l))
  }
}
