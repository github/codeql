/**
 * Defines entity discard predicates for Python overlay analysis.
 */

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
private string getPathForLocation(@location loc) {
  exists(@file file | locations_default(loc, file, _, _, _, _) | files(file, result))
  or
  exists(@py_Module mod | locations_ast(loc, mod, _, _, _, _) | result = getPathForModule(mod))
}

overlay[local]
private string getPathForModule(@py_Module mod) {
  exists(@container fileOrFolder | py_module_path(mod, fileOrFolder) |
    result = getPathForContainer(fileOrFolder)
  )
}

overlay[local]
private string getPathForContainer(@container fileOrFolder) {
  files(fileOrFolder, result) or folders(fileOrFolder, result)
}

/*- Discardable entities and their discard predicates -*/
overlay[local]
private class Discardable_ = @py_source_element or @py_flow_node or @py_base_var or @location;

overlay[discard_entity]
private predicate discardEntity(@py_source_element el) {
  // Within `@py_source_element`, only `@py_Module` and `@container`
  // use named IDs; the rest use *-ids.
  exists(Discardable d | d = el |
    overlayChangedFiles(d.getPath()) and
    d.existsInBase() and
    not d.existsInOverlay()
  )
}

overlay[discard_entity]
private predicate discardCfgNode(@py_flow_node n) {
  // `@py_flow_node`s use *-ids, so cannot exist both in base and overlay.
  exists(Discardable d | d = n |
    overlayChangedFiles(d.getPath()) and
    d.existsInBase()
  )
}

overlay[discard_entity]
private predicate discardVar(@py_base_var n) {
  // `@py_base_var`s use *-ids, so cannot exist both in base and overlay.
  exists(Discardable d | d = n |
    overlayChangedFiles(d.getPath()) and
    d.existsInBase()
  )
}

overlay[discard_entity]
private predicate discardLocation(@location loc) {
  // Locations use *-ids, so cannot exist both in base and overlay.
  exists(Discardable d | d = loc |
    overlayChangedFiles(d.getPath()) and
    d.existsInBase()
  )
}

/**
 * An abstract base class for all elements that can be discarded from the base.
 */
overlay[local]
abstract private class Discardable extends Discardable_ {
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
 * Discardable locatable AST nodes (`@py_location_parent`).
 */
overlay[local]
final private class DiscardableLocatable extends Discardable instanceof @py_location_parent {
  override string getPath() {
    exists(@location loc | py_locations(loc, this) | result = getPathForLocation(loc))
  }
}

/**
 * Discardable scopes (classes, functions, modules).
 */
overlay[local]
final private class DiscardableScope extends Discardable instanceof @py_scope {
  override string getPath() {
    exists(@location loc | py_scope_location(loc, this) | result = getPathForLocation(loc))
    or
    result = getPathForModule(this)
  }
}

/**
 * Discardable files and folders.
 */
overlay[local]
final private class DiscardableContainer extends Discardable instanceof @container {
  override string getPath() { result = getPathForContainer(this) }
}

/** Discardable control flow nodes */
overlay[local]
final private class DiscardableCfgNode extends Discardable instanceof @py_flow_node {
  override string getPath() {
    exists(Discardable d | result = d.getPath() |
      py_flow_bb_node(this, d.(@py_ast_node), _, _)
      or
      py_scope_flow(this, d.(@py_scope), _)
    )
  }
}

/** Discardable Python variables. */
overlay[local]
final private class DiscardableVar extends Discardable instanceof @py_variable {
  override string getPath() {
    exists(Discardable parent | result = parent.getPath() |
      variable(this, parent.(@py_scope), _)
      or
      py_variables(this, parent.(@py_variable_parent))
    )
  }
}

/** Discardable SSA variables. */
overlay[local]
final private class DiscardableSsaVar extends Discardable instanceof @py_ssa_var {
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

/** Discardable locations. */
overlay[local]
final private class DiscardableLocation extends Discardable instanceof @location {
  override string getPath() { result = getPathForLocation(this) }
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
