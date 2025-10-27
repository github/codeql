/**
 * Defines entity discard predicates for C# overlay analysis.
 */

/**
 * Holds always for the overlay variant and never for the base variant.
 * This local predicate is used to define local predicates that behave
 * differently for the base and overlay variant.
 */
overlay[local]
predicate isOverlay() { databaseMetadata("isOverlay", "true") }

/**
 * An abstract base class for all elements that can be discarded from the base.
 */
overlay[local]
abstract private class DiscardableEntity extends @locatable {
  /** Gets the path to the file in which this element occurs. */
  abstract string getPath();

  /** Holds if this element exists in the base variant. */
  predicate existsInBase() { not isOverlay() and exists(this) }

  /** Holds if this element exists in the overlay variant. */
  predicate existsInOverlay() { isOverlay() and exists(this) }

  /** Gets a textual representation of this discardable element. */
  string toString() { none() }
}

/**
 * A class of C# database entities that use `*` IDs.
 * The rest use named TRAP IDs.
 */
overlay[local]
private class StarEntity = @expr or @stmt;

overlay[discard_entity]
private predicate discardStarEntity(@locatable e) {
  e instanceof StarEntity and
  // Entities with *-ids can exist either in base or overlay, but not both.
  exists(DiscardableEntity de | de = e |
    overlayChangedFiles(de.getPath()) and
    de.existsInBase()
  )
}

overlay[discard_entity]
private predicate discardNamedEntity(@locatable e) {
  not e instanceof StarEntity and
  // Entities with named IDs can exist both in base, overlay, or both.
  exists(DiscardableEntity de | de = e |
    overlayChangedFiles(de.getPath()) and
    not de.existsInOverlay()
  )
}

overlay[local]
private string getLocationPath(@location_default loc) {
  exists(@file file | locations_default(loc, file, _, _, _, _) | files(file, result))
}

overlay[local]
private predicate discardableLocation(@location_default loc, string path) {
  not isOverlay() and
  path = getLocationPath(loc)
}

// Discard locations that are in changed files from the base variant.
overlay[discard_entity]
private predicate discardLocation(@location_default loc) {
  exists(string path | discardableLocation(loc, path) | overlayChangedFiles(path))
}

overlay[local]
private class PossibleDiscardableEntity extends DiscardableEntity instanceof @locatable {
  override string getPath() {
    exists(@location_default loc | result = getLocationPath(loc) |
      expr_location(this, loc) or
      stmt_location(this, loc) or
      using_directive_location(this, loc) or
      namespace_declaration_location(this, loc) or
      preprocessor_directive_location(this, loc) or
      type_location(this, loc) or
      attribute_location(this, loc) or
      type_parameter_constraints_location(this, loc) or
      property_location(this, loc) or
      indexer_location(this, loc) or
      accessor_location(this, loc) or
      event_location(this, loc) or
      event_accessor_location(this, loc) or
      operator_location(this, loc) or
      method_location(this, loc) or
      constructor_location(this, loc) or
      destructor_location(this, loc) or
      field_location(this, loc) or
      localvar_location(this, loc) or
      param_location(this, loc) or
      type_mention_location(this, loc) or
      commentline_location(this, loc) or
      commentblock_location(this, loc)
    )
  }
}
