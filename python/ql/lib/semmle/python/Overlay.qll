/**
 * Defines entity discard predicates for Python overlay analysis.
 */

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
/** Python database entities that use named TRAP IDs; the rest use *-ids. */
overlay[local]
private class NamedEntity = @py_Module or @container or @py_cobject;

overlay[discard_entity]
private predicate discardNamedEntity(@top el) {
  el instanceof NamedEntity and
  // Entities with named IDs can exist both in base, overlay, or both.
  exists(Discardable d | d = el |
    overlayChangedFiles(d.getPath()) and
    not d.existsInOverlay()
  )
}

overlay[discard_entity]
private predicate discardStarEntity(@top el) {
  not el instanceof NamedEntity and
  // Entities with *-ids can exist either in base or overlay, but not both.
  exists(Discardable d | d = el |
    overlayChangedFiles(d.getPath()) and
    d.existsInBase()
  )
}

/**
 * An abstract base class for all elements that can be discarded from the base.
 */
overlay[local]
abstract class Discardable extends @top {
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
    exists(Discardable d | result = d.getPath() | py_flow_bb_node(this, d.(@py_ast_node), _, _))
  }
}

/** Discardable Python variables. */
overlay[local]
final private class DiscardableVar extends Discardable instanceof @py_variable {
  override string getPath() {
    exists(Discardable parent | result = parent.getPath() | variable(this, parent.(@py_scope), _))
  }
}

/** Discardable SSA variables. */
overlay[local]
final private class DiscardableSsaVar extends Discardable instanceof @py_ssa_var {
  override string getPath() {
    exists(DiscardableVar other | result = other.getPath() | py_ssa_var(this, other))
  }
}

/** Discardable locations. */
overlay[local]
final private class DiscardableLocation extends Discardable instanceof @location {
  override string getPath() { result = getPathForLocation(this) }
}

/** Discardable lines. */
overlay[local]
final private class DiscardableLine extends Discardable instanceof @py_line {
  override string getPath() {
    exists(Discardable d | result = d.getPath() | py_line_lengths(this, d.(@py_Module), _, _))
  }
}

/** Discardable string part lists. */
overlay[local]
final private class DiscardableStringPartList extends Discardable instanceof @py_StringPart_list {
  override string getPath() {
    exists(Discardable d | result = d.getPath() | py_StringPart_lists(this, d.(@py_Bytes_or_Str)))
  }
}

/** Discardable alias */
overlay[local]
final private class DiscardableAlias extends Discardable instanceof @py_alias {
  override string getPath() {
    exists(DiscardableAliasList d | result = d.getPath() | py_aliases(this, d, _))
  }
}

/** Discardable alias list */
overlay[local]
final private class DiscardableAliasList extends Discardable instanceof @py_alias_list {
  override string getPath() {
    exists(Discardable d | result = d.getPath() | py_alias_lists(this, d.(@py_Import)))
  }
}

/** Discardable arguments */
overlay[local]
final private class DiscardableArguments extends Discardable instanceof @py_arguments {
  override string getPath() {
    exists(Discardable d | result = d.getPath() | py_arguments(this, d.(@py_arguments_parent)))
  }
}

/** Discardable boolop */
overlay[local]
final private class DiscardableBoolOp extends Discardable instanceof @py_boolop {
  override string getPath() {
    exists(Discardable d | result = d.getPath() | py_boolops(this, _, d.(@py_BoolExpr)))
  }
}

/** Discardable cmpop */
overlay[local]
final private class DiscardableCmpOp extends Discardable instanceof @py_cmpop {
  override string getPath() {
    exists(DiscardableCmpOpList d | result = d.getPath() | py_cmpops(this, _, d, _))
  }
}

/** Discardable cmpop list */
overlay[local]
final private class DiscardableCmpOpList extends Discardable instanceof @py_cmpop_list {
  override string getPath() {
    exists(Discardable d | result = d.getPath() | py_cmpop_lists(this, d.(@py_Compare)))
  }
}

/** Discardable comprehension list */
overlay[local]
final private class DiscardableComprehensionList extends Discardable instanceof @py_comprehension_list
{
  override string getPath() {
    exists(Discardable d | result = d.getPath() | py_comprehension_lists(this, d.(@py_ListComp)))
  }
}

/** Discardable dict item list */
overlay[local]
final private class DiscardableDictItemList extends Discardable instanceof @py_dict_item_list {
  override string getPath() {
    exists(Discardable d | result = d.getPath() |
      py_dict_item_lists(this, d.(@py_dict_item_list_parent))
    )
  }
}

/** Discardable expr context */
overlay[local]
final private class DiscardableExprContext extends Discardable instanceof @py_expr_context {
  override string getPath() {
    exists(Discardable d | result = d.getPath() |
      py_expr_contexts(this, _, d.(@py_expr_context_parent))
    )
  }
}

/** Discardable expr list */
overlay[local]
final private class DiscardableExprList extends Discardable instanceof @py_expr_list {
  override string getPath() {
    exists(Discardable d | result = d.getPath() | py_expr_lists(this, d.(@py_expr_list_parent), _))
  }
}

/** Discardable operator */
overlay[local]
final private class DiscardableOperator extends Discardable instanceof @py_operator {
  override string getPath() {
    exists(Discardable d | result = d.getPath() | py_operators(this, _, d.(@py_BinaryExpr)))
  }
}

/** Discardable parameter list */
overlay[local]
final private class DiscardableParameterList extends Discardable instanceof @py_parameter_list {
  override string getPath() {
    exists(Discardable d | result = d.getPath() | py_parameter_lists(this, d.(@py_Function)))
  }
}

/** Discardable pattern list */
overlay[local]
final private class DiscardablePatternList extends Discardable instanceof @py_pattern_list {
  override string getPath() {
    exists(Discardable d | result = d.getPath() |
      py_pattern_lists(this, d.(@py_pattern_list_parent), _)
    )
  }
}

/** Discardable stmt list */
overlay[local]
final private class DiscardableStmtList extends Discardable instanceof @py_stmt_list {
  override string getPath() {
    exists(Discardable d | result = d.getPath() | py_stmt_lists(this, d.(@py_stmt_list_parent), _))
  }
}

/** Discardable str list */
overlay[local]
final private class DiscardableStrList extends Discardable instanceof @py_str_list {
  override string getPath() {
    exists(Discardable d | result = d.getPath() | py_str_lists(this, d.(@py_str_list_parent)))
  }
}

/** Discardable type parameter list */
overlay[local]
final private class DiscardableTypeParameterList extends Discardable instanceof @py_type_parameter_list
{
  override string getPath() {
    exists(Discardable d | result = d.getPath() |
      py_type_parameter_lists(this, d.(@py_type_parameter_list_parent))
    )
  }
}

/** Discardable unaryop */
overlay[local]
final private class DiscardableUnaryOp extends Discardable instanceof @py_unaryop {
  override string getPath() {
    exists(Discardable d | result = d.getPath() | py_unaryops(this, _, d.(@py_UnaryExpr)))
  }
}

/** Discardable comment */
overlay[local]
final private class DiscardableComment extends Discardable instanceof @py_comment {
  override string getPath() {
    exists(DiscardableLocation d | result = d.getPath() | py_comments(this, _, d))
  }
}

/*- XML -*/
overlay[local]
final private class DiscardableXmlLocatable extends Discardable instanceof @xmllocatable {
  override string getPath() {
    exists(@location loc | xmllocations(this, loc) | result = getPathForLocation(loc))
  }
}

overlay[local]
private predicate overlayXmlExtracted(string path) {
  exists(DiscardableXmlLocatable d | not files(d, _) and not xmlNs(d, _, _, _) |
    d.existsInOverlay() and
    path = d.getPath()
  )
}

overlay[discard_entity]
private predicate discardXmlLocatable(@xmllocatable el) {
  exists(DiscardableXmlLocatable d | d = el |
    // The XML extractor is currently not incremental and may extract more
    // XML files than those included in `overlayChangedFiles`, so this discard predicate
    // handles those files alongside the normal `discardStarEntity` logic.
    overlayXmlExtracted(d.getPath()) and
    d.existsInBase()
  )
}

/*- YAML -*/
overlay[local]
final private class DiscardableYamlLocatable extends Discardable instanceof @yaml_locatable {
  override string getPath() {
    exists(@location loc | yaml_locations(this, loc) | result = getPathForLocation(loc))
  }
}

overlay[local]
private predicate overlayYamlExtracted(string path) {
  exists(DiscardableYamlLocatable l | l.existsInOverlay() | path = l.getPath())
}

overlay[discard_entity]
private predicate discardBaseYamlLocatable(@yaml_locatable el) {
  exists(DiscardableYamlLocatable d | d = el |
    // The Yaml extractor is currently not incremental and may extract more
    // Yaml files than those included in `overlayChangedFiles`, so this discard predicate
    // handles those files alongside the normal `discardStarEntity` logic.
    overlayYamlExtracted(d.getPath()) and
    d.existsInBase()
  )
}
