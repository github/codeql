import default
import semmle.code.configfiles.ConfigFiles

from ConfigPair cp
select cp.getEffectiveName(), cp.getEffectiveValue()
