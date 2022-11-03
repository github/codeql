import semmle.javascript.SourceMaps

from SourceMappingComment smc
select smc, smc.getSourceMappingURL()
