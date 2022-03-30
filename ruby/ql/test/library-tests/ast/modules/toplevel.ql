import ruby

query predicate toplevel(Toplevel m, string pClass) { pClass = m.getAPrimaryQlClass() }

query predicate beginBlocks(Toplevel m, int i, BeginBlock b) { b = m.getBeginBlock(i) }

query predicate endBlocks(Toplevel m, EndBlock b) {
  b.getLocation().getFile() = m.getLocation().getFile()
}
