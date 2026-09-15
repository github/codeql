import codeql.rust.elements

private predicate inUpgradeShapesFile(Locatable loc) {
  loc.getFile().getBaseName() = "upgrade_shapes.rs"
}

query predicate formatArgsArgName(FormatArgsArg arg, Name argName, Expr expr, string nameText) {
  inUpgradeShapesFile(arg) and
  argName = arg.getName() and
  expr = arg.getExpr() and
  nameText = argName.getText()
}

query predicate tryBlock(BlockExpr block) {
  inUpgradeShapesFile(block) and
  block.isTry()
}

query predicate structFieldDefault(StructField field, Expr defaultVal) {
  inUpgradeShapesFile(field) and
  defaultVal = field.getDefault()
}

query predicate variantDiscriminant(Variant variant, Expr discriminant) {
  inUpgradeShapesFile(variant) and
  discriminant = variant.getDiscriminant()
}

query predicate metaPath(Meta meta, string pathText) {
  inUpgradeShapesFile(meta) and
  pathText = meta.getPath().getText()
}

query predicate metaExpr(Meta meta, Expr expr) {
  inUpgradeShapesFile(meta) and
  expr = meta.getExpr()
}

query predicate metaTokenTree(Meta meta, TokenTree tokenTree) {
  inUpgradeShapesFile(meta) and
  tokenTree = meta.getTokenTree()
}

query predicate metaIsUnsafe(Meta meta) {
  inUpgradeShapesFile(meta) and
  meta.isUnsafe()
}

query predicate traitAlias(
  TraitAlias alias, Name name, TypeBoundList bounds, WhereClause whereClause
) {
  inUpgradeShapesFile(alias) and
  name = alias.getName() and
  bounds = alias.getTypeBoundList() and
  whereClause = alias.getWhereClause()
}
