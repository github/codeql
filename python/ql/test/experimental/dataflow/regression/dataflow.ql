import config

from
  DataFlow::Node source,
  DataFlow::Node sink
where
  // source != sink and 
  exists(TestConfiguration cfg | cfg.hasFlow(source, sink))
select
  source, sink
