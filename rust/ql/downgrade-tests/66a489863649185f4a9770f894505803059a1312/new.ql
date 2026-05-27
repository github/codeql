import codeql.rust.elements

private predicate inUpgradeShapesFile(Locatable loc) {
  loc.getFile().getBaseName() = "upgrade_shapes.rs"
}

query predicate formatArgNamePreserved(
  FormatArgsArg arg, FormatArgsArgName argName, Expr expr, int argNameColumn, string exprText
) {
  inUpgradeShapesFile(arg) and
  argName = arg.getArgName() and
  expr = arg.getExpr() and
  argNameColumn = argName.getLocation().getStartColumn() and
  exprText = expr.toString()
}

query predicate tryBlockModifierPreserved(BlockExpr block, TryBlockModifier modifier) {
  inUpgradeShapesFile(block) and
  modifier = block.getTryBlockModifier() and
  modifier.isTry() and
  not modifier.hasTypeRepr()
}

query predicate structFieldDefaultPreserved(StructField field, ConstArg defaultVal, Expr expr) {
  inUpgradeShapesFile(field) and
  defaultVal = field.getDefaultVal() and
  expr = defaultVal.getExpr()
}

query predicate variantDiscriminantPreserved(Variant variant, ConstArg constArg, Expr expr) {
  inUpgradeShapesFile(variant) and
  constArg = variant.getConstArg() and
  expr = constArg.getExpr()
}

query predicate pathMetaPreserved(PathMeta meta, string pathText) {
  inUpgradeShapesFile(meta) and
  pathText = meta.getPath().getText() and
  pathText = "path_meta"
}

query predicate keyValueMetaPreserved(KeyValueMeta meta, string pathText, Expr expr) {
  inUpgradeShapesFile(meta) and
  pathText = meta.getPath().getText() and
  pathText = "key_value" and
  expr = meta.getExpr()
}

query predicate tokenTreeMetaPreserved(TokenTreeMeta meta, string pathText, TokenTree tokenTree) {
  inUpgradeShapesFile(meta) and
  pathText = meta.getPath().getText() and
  pathText = "token_tree" and
  tokenTree = meta.getTokenTree()
}

query predicate unsafeMetaPreserved(UnsafeMeta meta, PathMeta inner, string pathText) {
  inUpgradeShapesFile(meta) and
  meta.isUnsafe() and
  inner = meta.getMeta() and
  pathText = inner.getPath().getText() and
  pathText = "path_meta"
}

query predicate traitAliasPreserved(
  Trait trait, Name name, TypeBoundList bounds, WhereClause whereClause
) {
  inUpgradeShapesFile(trait) and
  name = trait.getName() and
  name.getText() = "Alias" and
  bounds = trait.getTypeBoundList() and
  whereClause = trait.getWhereClause() and
  not trait.hasAssocItemList()
}
