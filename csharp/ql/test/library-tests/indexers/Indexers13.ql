import csharp

from IndexerCall ic, Indexer i, Accessor target
where
  ic.getIndexer() = i and
  ic.getTarget() = target and
  i.fromSource()
select i, ic, target
