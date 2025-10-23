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
abstract private class DiscardableEntity extends @element {
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
private predicate discardStarEntity(@element e) {
  e instanceof StarEntity and
  // Entities with *-ids can exist either in base or overlay, but not both.
  exists(DiscardableEntity de | de = e |
    overlayChangedFiles(de.getPath()) and
    de.existsInBase()
  )
}

overlay[discard_entity]
private predicate discardNamedEntity(@element e) {
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
private class ExprEntity extends DiscardableEntity instanceof @expr {
  override string getPath() {
    exists(@location_default loc | expr_location(this, loc) | result = getLocationPath(loc))
  }
}

overlay[local]
private class StmtEntity extends DiscardableEntity instanceof @stmt {
  override string getPath() {
    exists(@location_default loc | stmt_location(this, loc) | result = getLocationPath(loc))
  }
}

overlay[local]
private class UsingDirectiveEntity extends DiscardableEntity instanceof @using_directive {
  override string getPath() {
    exists(@location_default loc | using_directive_location(this, loc) |
      result = getLocationPath(loc)
    )
  }
}

overlay[local]
private class NamespaceDeclarationEntity extends DiscardableEntity instanceof @namespace_declaration
{
  override string getPath() {
    exists(@location_default loc | namespace_declaration_location(this, loc) |
      result = getLocationPath(loc)
    )
  }
}

overlay[local]
private class PreprocessorDirectiveEntity extends DiscardableEntity instanceof @preprocessor_directive
{
  override string getPath() {
    exists(@location_default loc | preprocessor_directive_location(this, loc) |
      result = getLocationPath(loc)
    )
  }
}

overlay[local]
private class TypeEntity extends DiscardableEntity instanceof @type {
  override string getPath() {
    exists(@location_default loc | type_location(this, loc) | result = getLocationPath(loc))
  }
}

overlay[local]
private class AttributeEntity extends DiscardableEntity instanceof @attribute {
  override string getPath() {
    exists(@location_default loc | attribute_location(this, loc) | result = getLocationPath(loc))
  }
}

overlay[local]
private class TypeParameterConstraintsEntity extends DiscardableEntity instanceof @type_parameter_constraints
{
  override string getPath() {
    exists(@location_default loc | type_parameter_constraints_location(this, loc) |
      result = getLocationPath(loc)
    )
  }
}

overlay[local]
private class PropertyEntity extends DiscardableEntity instanceof @property {
  override string getPath() {
    exists(@location_default loc | property_location(this, loc) | result = getLocationPath(loc))
  }
}

overlay[local]
private class IndexerEntity extends DiscardableEntity instanceof @indexer {
  override string getPath() {
    exists(@location_default loc | indexer_location(this, loc) | result = getLocationPath(loc))
  }
}

overlay[local]
private class AccessorEntity extends DiscardableEntity instanceof @accessor {
  override string getPath() {
    exists(@location_default loc | accessor_location(this, loc) | result = getLocationPath(loc))
  }
}

overlay[local]
private class EventEntity extends DiscardableEntity instanceof @event {
  override string getPath() {
    exists(@location_default loc | event_location(this, loc) | result = getLocationPath(loc))
  }
}

overlay[local]
private class EventAccessorEntity extends DiscardableEntity instanceof @event_accessor {
  override string getPath() {
    exists(@location_default loc | event_accessor_location(this, loc) |
      result = getLocationPath(loc)
    )
  }
}

overlay[local]
private class OperatorEntity extends DiscardableEntity instanceof @operator {
  override string getPath() {
    exists(@location_default loc | operator_location(this, loc) | result = getLocationPath(loc))
  }
}

overlay[local]
private class MethodEntity extends DiscardableEntity instanceof @method {
  override string getPath() {
    exists(@location_default loc | method_location(this, loc) | result = getLocationPath(loc))
  }
}

overlay[local]
private class ConstructorEntity extends DiscardableEntity instanceof @constructor {
  override string getPath() {
    exists(@location_default loc | constructor_location(this, loc) | result = getLocationPath(loc))
  }
}

overlay[local]
private class DestructorEntity extends DiscardableEntity instanceof @destructor {
  override string getPath() {
    exists(@location_default loc | destructor_location(this, loc) | result = getLocationPath(loc))
  }
}

overlay[local]
private class FieldEntity extends DiscardableEntity instanceof @field {
  override string getPath() {
    exists(@location_default loc | field_location(this, loc) | result = getLocationPath(loc))
  }
}

overlay[local]
private class LocalVariableEntity extends DiscardableEntity instanceof @local_variable {
  override string getPath() {
    exists(@location_default loc | localvar_location(this, loc) | result = getLocationPath(loc))
  }
}

overlay[local]
private class ParameterEntity extends DiscardableEntity instanceof @parameter {
  override string getPath() {
    exists(@location_default loc | param_location(this, loc) | result = getLocationPath(loc))
  }
}
// TODO: We Still need to handle commentline, comment block entities and type mentions.
