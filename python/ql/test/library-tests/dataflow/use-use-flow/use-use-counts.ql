import python
private import semmle.python.controlflow.internal.Cfg as Cfg
private import semmle.python.dataflow.new.internal.SsaImpl as SsaImpl
private import semmle.python.dataflow.new.internal.DataFlowPrivate

query int implicit_use_count() {
  exists(SsaImpl::SsaSourceVariable x | x.getName() = "x" | result = count(x.getAnImplicitUse()))
}

query Cfg::ControlFlowNode implicit_use() {
  exists(SsaImpl::SsaSourceVariable x | x.getName() = "x" | result = x.getAnImplicitUse())
}

query int source_use_count() {
  exists(SsaImpl::SsaSourceVariable x | x.getName() = "x" | result = count(x.getASourceUse()))
}

query Cfg::ControlFlowNode source_use() {
  exists(SsaImpl::SsaSourceVariable x | x.getName() = "x" | result = x.getASourceUse())
}

query int use_use_edge_count() {
  exists(SsaImpl::SsaSourceVariable x | x.getName() = "x" |
    result =
      count(Cfg::NameNode use1, Cfg::NameNode use2 |
        use1 = x.getAUse() and
        use2 = x.getAUse() and
        LocalFlow::useToNextUse(use1, use2)
      )
  )
}

query predicate use_use_edge(Cfg::NameNode use1, Cfg::NameNode use2) {
  exists(SsaImpl::SsaSourceVariable x | x.getName() = "x" |
    use1 = x.getAUse() and
    use2 = x.getAUse() and
    LocalFlow::useToNextUse(use1, use2)
  )
}
