import config

from
  DataFlow::Node source,
  DataFlow::Node sink
where
  exists(TestConfiguration cfg | cfg.hasFlow(source, sink))
select
  source, sink
