import python
private import semmle.python.controlflow.internal.AstNodeImpl as CfgImpl
private import semmle.python.controlflow.internal.Cfg as Cfg
private import semmle.python.dataflow.new.internal.SsaImpl as SsaImpl

private predicate projectedFirstUse(SsaImpl::Definition def, Cfg::NameNode use) {
  exists(CfgImpl::BasicBlock bb, int i |
    SsaImpl::Impl::firstUse(def, bb, i, _) and
    use = bb.getNode(i)
  )
}

private predicate projectedAdjacentUse(Cfg::NameNode nodeFrom, Cfg::NameNode nodeTo) {
  exists(CfgImpl::BasicBlock bb1, int i1, CfgImpl::BasicBlock bb2, int i2 |
    SsaImpl::Impl::adjacentUseUse(bb1, i1, bb2, i2, _, _) and
    nodeFrom = bb1.getNode(i1) and
    nodeTo = bb2.getNode(i2)
  )
}

private predicate expandedUseOfDef(SsaImpl::Definition def, Cfg::NameNode use) {
  exists(Cfg::NameNode first |
    SsaImpl::AdjacentUses::firstUse(def, first) and
    SsaImpl::AdjacentUses::adjacentUseUse*(first, use)
  )
}

query int exposed_first_use_count() {
  result =
    count(SsaImpl::Definition def, Cfg::NameNode use | SsaImpl::AdjacentUses::firstUse(def, use))
}

query int exposed_adjacent_use_count() {
  result =
    count(Cfg::NameNode nodeFrom, Cfg::NameNode nodeTo |
      SsaImpl::AdjacentUses::adjacentUseUse(nodeFrom, nodeTo)
    )
}

query int exposed_use_of_def_count() {
  result =
    count(SsaImpl::Definition def, Cfg::NameNode use | SsaImpl::AdjacentUses::useOfDef(def, use))
}

query int first_use_projection_mismatch_count() {
  result =
    count(SsaImpl::Definition def, Cfg::NameNode use |
      SsaImpl::AdjacentUses::firstUse(def, use) and not projectedFirstUse(def, use)
      or
      projectedFirstUse(def, use) and not SsaImpl::AdjacentUses::firstUse(def, use)
    )
}

query int adjacent_use_projection_mismatch_count() {
  result =
    count(Cfg::NameNode nodeFrom, Cfg::NameNode nodeTo |
      SsaImpl::AdjacentUses::adjacentUseUse(nodeFrom, nodeTo) and
      not projectedAdjacentUse(nodeFrom, nodeTo)
      or
      projectedAdjacentUse(nodeFrom, nodeTo) and
      not SsaImpl::AdjacentUses::adjacentUseUse(nodeFrom, nodeTo)
    )
}

query int use_of_def_expansion_mismatch_count() {
  result =
    count(SsaImpl::Definition def, Cfg::NameNode use |
      SsaImpl::AdjacentUses::useOfDef(def, use) and not expandedUseOfDef(def, use)
      or
      expandedUseOfDef(def, use) and not SsaImpl::AdjacentUses::useOfDef(def, use)
    )
}
