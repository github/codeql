import python
private import semmle.python.dataflow.new.internal.DataFlowPrivate

query int def_count() {
  exists(SsaSourceVariable x | x.getName() = "x" |
    result = count(EssaNodeDefinition def | def.getSourceVariable() = x)
  )
}

query EssaNodeDefinition def() {
  exists(SsaSourceVariable x | x.getName() = "x" | result.getSourceVariable() = x)
}

query int implicit_use_count() {
  exists(SsaSourceVariable x | x.getName() = "x" | result = count(x.getAnImplicitUse()))
}

query ControlFlowNode implicit_use() {
  exists(SsaSourceVariable x | x.getName() = "x" | result = x.getAnImplicitUse())
}

query int source_use_count() {
  exists(SsaSourceVariable x | x.getName() = "x" | result = count(x.getASourceUse()))
}

query ControlFlowNode source_use() {
  exists(SsaSourceVariable x | x.getName() = "x" | result = x.getASourceUse())
}

query int def_use_edge_count() {
  exists(SsaSourceVariable x | x.getName() = "x" |
    result =
      count(EssaVariable v, NameNode use |
        v.getSourceVariable() = x and
        use = x.getAUse() and
        LocalFlow::defToFirstUse(v, use)
      )
  )
}

query predicate def_use_edge(EssaVariable v, NameNode use) {
  exists(SsaSourceVariable x | x.getName() = "x" |
    v.getSourceVariable() = x and
    use = x.getAUse() and
    LocalFlow::defToFirstUse(v, use)
  )
}
