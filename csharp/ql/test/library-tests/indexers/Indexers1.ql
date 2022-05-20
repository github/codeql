/**
 * @name Test for indexers
 */

import csharp

where forall(Indexer i | i.fromSource() | i.hasName("Item"))
select 1
