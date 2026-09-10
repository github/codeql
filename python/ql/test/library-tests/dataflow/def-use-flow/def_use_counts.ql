import python
private import semmle.python.controlflow.internal.Cfg as Cfg
private import semmle.python.dataflow.new.internal.SsaImpl as SsaImpl
private import semmle.python.dataflow.new.internal.DataFlowPrivate

query int def_count() {
  exists(SsaImpl::SsaSourceVariable x | x.getName() = "x" |
    result = count(SsaImpl::EssaNodeDefinition def | def.getSourceVariable() = x)
  )
}

query SsaImpl::EssaNodeDefinition def() {
  exists(SsaImpl::SsaSourceVariable x | x.getName() = "x" | result.getSourceVariable() = x)
}

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

query int def_use_edge_count() {
  exists(SsaImpl::SsaSourceVariable x | x.getName() = "x" |
    result =
      count(SsaImpl::EssaVariable v, Cfg::NameNode use |
        v.getSourceVariable() = x and
        use = x.getAUse() and
        LocalFlow::defToFirstUse(v, use)
      )
  )
}

query predicate def_use_edge(SsaImpl::EssaVariable v, Cfg::NameNode use) {
  exists(SsaImpl::SsaSourceVariable x | x.getName() = "x" |
    v.getSourceVariable() = x and
    use = x.getAUse() and
    LocalFlow::defToFirstUse(v, use)
  )
}
