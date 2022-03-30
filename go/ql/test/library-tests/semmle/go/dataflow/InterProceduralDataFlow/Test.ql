import go

class MyConfiguration extends DataFlow::Configuration {
  MyConfiguration() { this = "MyConfiguration" }

  override predicate isSource(DataFlow::Node nd) {
    exists(ValueEntity v, Write w |
      v.getName().matches("source%") and
      w.writes(v, nd)
    )
  }

  override predicate isSink(DataFlow::Node nd) {
    exists(ValueEntity v, Write w |
      v.getName().matches("sink%") and
      w.writes(v, nd)
    )
  }
}

from MyConfiguration cfg, DataFlow::Node source, DataFlow::Node sink
where cfg.hasFlow(source, sink)
select source, sink
