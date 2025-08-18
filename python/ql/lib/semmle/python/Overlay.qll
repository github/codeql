/**
 * Defines entity discard predicates for Python overlay analysis.
 */
overlay[local?]
module;

import python

/*- Predicates -*/
/**
 * Holds always for the overlay variant and never for the base variant.
 * This local predicate is used to define local predicates that behave
 * differently for the base and overlay variant.
 */
overlay[local]
predicate isOverlay() { databaseMetadata("isOverlay", "true") }

overlay[local]
private string getRawPathForLocation(@location loc) {
  exists(@file file | locations_default(loc, file, _, _, _, _) | files(file, result))
  or
  exists(@py_Module mod | locations_ast(loc, mod, _, _, _, _) | result = getRawPathForModule(mod))
}

overlay[local]
private string getRawPathForModule(@py_Module mod) {
  exists(@container fileOrFolder | py_module_path(mod, fileOrFolder) |
    result = getRawPathForContainer(fileOrFolder)
  )
}

overlay[local]
private string getRawPathForContainer(@container fileOrFolder) {
  files(fileOrFolder, result) or folders(fileOrFolder, result)
}

/*- Source elements -*/
/**
 * An abstract base class for all elements that can be discarded from the base.
 */
overlay[local]
abstract private class Discardable extends @py_source_element {
  /** Gets the path to the file in which this element occurs. */
  abstract string getPath();

  /** Holds if this element exists in the base variant. */
  predicate existsInBase() { not isOverlay() and exists(this) }

  /** Holds if this element exists in the overlay variant. */
  predicate existsInOverlay() { isOverlay() and exists(this) }

  /** Gets a textual representation of this discardable element. */
  string toString() { none() }
}

overlay[discard_entity]
private predicate discardEntity(@py_source_element el) {
  exists(Discardable d | d = el |
    overlayChangedFiles(d.getPath()) and
    d.existsInBase() and
    not d.existsInOverlay()
  )
}

/**
 * Discard all locatable AST nodes (`@py_location_parent`) in modified files
 * since they use *-ids and hence cannot be referenced across TRAP files.
 */
overlay[local]
final private class DiscardableLocatable extends Discardable instanceof @py_location_parent {
  override string getPath() {
    exists(@location loc | py_locations(loc, this) | result = getRawPathForLocation(loc))
  }
}

/**
 * Discard scopes (classes, functions, modules) that were deleted in the overlay.
 */
overlay[local]
final private class DiscardableScope extends Discardable instanceof @py_scope {
  override string getPath() {
    exists(@location loc | py_scope_location(loc, this) | result = getRawPathForLocation(loc))
    or
    result = getRawPathForModule(this)
  }
}

/**
 * Discard files and folders that were deleted in the overlay.
 */
overlay[local]
final private class DiscardableContainer extends Discardable instanceof @container {
  override string getPath() { result = getRawPathForContainer(this) }
}

/*- CFG Nodes -*/
/** Discardable control flow nodes */
overlay[local]
final private class DiscardableCfgNode instanceof @py_flow_node {
  string getPath() {
    exists(Discardable d | result = d.getPath() |
      py_flow_bb_node(this, d.(@py_ast_node), _, _)
      or
      py_scope_flow(this, d.(@py_scope), _)
    )
  }

  predicate existsInBase() { not isOverlay() and exists(this) }

  predicate existsInOverlay() { isOverlay() and exists(this) }

  string toString() { none() }
}

overlay[discard_entity]
private predicate discardCfgNode(@py_flow_node n) {
  exists(DiscardableCfgNode d | d = n |
    overlayChangedFiles(d.getPath()) and
    d.existsInBase() and
    not d.existsInOverlay()
  )
}

/*- Variables -*/
/** Discardable (normal and SSA) variables */
overlay[local]
abstract private class DiscardableBaseVar instanceof @py_base_var {
  abstract string getPath();

  predicate existsInBase() { not isOverlay() and exists(this) }

  predicate existsInOverlay() { isOverlay() and exists(this) }

  string toString() { none() }
}

overlay[discard_entity]
private predicate discardVar(@py_base_var n) {
  exists(DiscardableVar d | d = n |
    overlayChangedFiles(d.getPath()) and
    d.existsInBase() and
    not d.existsInOverlay()
  )
}

final private class DiscardableVar extends DiscardableBaseVar instanceof @py_variable {
  override string getPath() {
    exists(Discardable parent | result = parent.getPath() |
      variable(this, parent.(@py_scope), _)
      or
      py_variables(this, parent.(@py_variable_parent))
    )
  }
}

final private class DiscardableSsaVar extends DiscardableBaseVar instanceof @py_ssa_var {
  override string getPath() {
    exists(DiscardableSsaVar other | result = other.getPath() |
      py_ssa_phi(this, other.(@py_ssa_var))
    )
    or
    exists(DiscardableVar other | result = other.getPath() | py_ssa_var(this, other))
    or
    exists(DiscardableCfgNode node | result = node.getPath() |
      py_ssa_use(node, this)
      or
      py_ssa_defn(this, node)
    )
  }
}

/*- Locations -*/
overlay[local]
private predicate locationExistsInBase(@location loc) { not isOverlay() and exists(loc) }

overlay[local]
private predicate locationExistsInOverlay(@location loc) { isOverlay() and exists(loc) }

overlay[discard_entity]
private predicate discardLocation(@location loc) {
  overlayChangedFiles(getRawPathForLocation(loc)) and
  locationExistsInBase(loc) and
  not locationExistsInOverlay(loc)
}

/*- XML -*/
overlay[local]
private predicate baseXmlLocatable(@xmllocatable l) {
  not isOverlay() and not files(l, _) and not xmlNs(l, _, _, _)
}

overlay[local]
private predicate overlayHasXmlLocatable() {
  isOverlay() and
  exists(@xmllocatable l | not files(l, _) and not xmlNs(l, _, _, _))
}

overlay[discard_entity]
private predicate discardBaseXmlLocatable(@xmllocatable el) {
  // The XML extractor is currently not incremental, so if
  // the overlay contains any XML locatables, the overlay should
  // contain a full extraction and all XML locatables from base
  // should be discarded.
  baseXmlLocatable(el) and overlayHasXmlLocatable()
}

/*- YAML -*/
overlay[local]
private predicate baseYamlLocatable(@yaml_locatable l) { not isOverlay() and exists(l) }

overlay[local]
private predicate overlayHasYamlLocatable() {
  isOverlay() and
  exists(@yaml_locatable l)
}

overlay[discard_entity]
private predicate discardBaseYamlLocatable(@yaml_locatable el) {
  // The Yaml extractor is currently not incremental, so if
  // the overlay contains any Yaml locatables, the overlay should
  // contain a full extraction and all Yaml locatables from base
  // should be discarded.
  baseYamlLocatable(el) and overlayHasYamlLocatable()
}
